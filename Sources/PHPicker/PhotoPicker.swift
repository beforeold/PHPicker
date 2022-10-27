
import SwiftUI
import PhotosUI

public struct PhotoPicker: UIViewControllerRepresentable {
  public typealias UIViewControllerType = PHPickerViewController
  
  /// Can be .images, .livePhotos or .videos
  public let filter: PHPickerFilter
  
  /// How many photos can be selected. 0 means no limit.
  public let limit: Int
  
  ///  callback of the photo
  @Binding var photo: UIImage?
  
  public init(photo: Binding<UIImage?>,
              filter: PHPickerFilter = .images,
              limit: Int = 1) {
    self.filter = filter
    self.limit = limit
    self._photo = photo
  }
  
  public func makeUIViewController(context: Context) -> PHPickerViewController {
    
    // Create the picker configuration using the properties passed in above.
    var configuration = PHPickerConfiguration()
    configuration.filter = filter
    configuration.selectionLimit = limit
    
    // Create the view controller.
    let controller = PHPickerViewController(configuration: configuration)
    
    // Link it to the Coordinator created below.
    controller.delegate = context.coordinator
    
    return controller
  }
  
  // This method is blank because it will never be updated.
  public func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}
  
  public func makeCoordinator() -> Coordinator {
    return Coordinator(self)
  }
  
  public class Coordinator: PHPickerViewControllerDelegate {
    
    // The coordinator needs a reference to the thing it's linked to.
    private let parent: PhotoPicker
    
    init(_ parent: PhotoPicker) {
      self.parent = parent
    }
    
    // Called when the user finishes picking a photo.
    public func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
      // Dismiss the picker.
      picker.dismiss(animated: true)
      
      // Exit if no selection was made
      guard let provider = results.first?.itemProvider else { return }
      
      // If this has an image we can use, use it
      guard provider.canLoadObject(ofClass: UIImage.self) else { return }
            
      provider.loadObject(ofClass: UIImage.self) { image, _ in
        self.parent.photo = image as? UIImage
      }
    }
  }
}
