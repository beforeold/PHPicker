import XCTest
@testable import PHPicker

final class PHPickerTests: XCTestCase {
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        
        let picker = PhotoPicker(photo: .constant(nil))
        print(picker)
    }
}
