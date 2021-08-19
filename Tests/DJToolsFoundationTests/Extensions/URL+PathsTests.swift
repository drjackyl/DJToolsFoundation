import XCTest
@testable import DJToolsFoundation





class URL_PathsTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    // MARK: - hasBaseURL()
    
    func testHasBaseURL_WithRegularBaseURL() {
        let baseURL = URL(fileURLWithPath: "/Users/Holger/MyBase")
        let otherURL = URL(fileURLWithPath: "Relative/Sub", relativeTo: baseURL)
        
        XCTAssertTrue(otherURL.hasBaseURL(baseURL))
    }
    
    func testHasBaseURL_WithURL() {
        let baseURL = URL(fileURLWithPath: "/Users/Andreas/MyBase")
        let otherURL = URL(fileURLWithPath: "/Users/Andreas/MyBase/Relative/Sub")
        
        XCTAssertTrue(otherURL.hasBaseURL(baseURL))
    }
    
    func testHasBaseURL_WithDifferentSchemes() {
        let baseURL = URL(fileURLWithPath: "/Users/Uwe/MyBase")
        let otherURL = URL(string: "https:///Users/Uwe/MyBas")!
        
        XCTAssertFalse(otherURL.hasBaseURL(baseURL))
    }
    
    // MARK: - makeRelativeToURL()
    
    func testMakeRelativeToURL() {
        let baseURL = URL(fileURLWithPath: "/Users/Horst/MyBase")
        let otherURL = URL(fileURLWithPath: "/Users/Horst/MyBase/Relative/Sub")
        
        let result = otherURL.makeRelativeToBaseURL(baseURL)
        
        XCTAssertNotNil(result)
        XCTAssertEqual(baseURL, result?.baseURL)
        XCTAssertEqual("Relative/Sub", result?.relativePath)
    }
    
    func testMakeRelativeToURL_BaseURLWithTrailingSlash() {
        let baseURL = URL(fileURLWithPath: "/Users/Horst/MyBase/")
        let otherURL = URL(fileURLWithPath: "/Users/Horst/MyBase/Relative/Sub/")
        
        let result = otherURL.makeRelativeToBaseURL(baseURL)
        
        XCTAssertNotNil(result)
        XCTAssertEqual(baseURL, result?.baseURL)
        XCTAssertEqual("Relative/Sub", result?.relativePath)
    }
    
    func testMakeRelativeToURL_OtherURLWithTrailingSlash() {
        let baseURL = URL(fileURLWithPath: "/Users/Horst/MyBase")
        let otherURL = URL(fileURLWithPath: "/Users/Horst/MyBase/Relative/Sub")
        
        let result = otherURL.makeRelativeToBaseURL(baseURL)
        
        XCTAssertNotNil(result)
        XCTAssertEqual(baseURL, result?.baseURL)
        XCTAssertEqual("Relative/Sub", result?.relativePath)
    }
    
    func testMakeRelativeToURL_OtherURLWithStandardizablePath() {
        let baseURL = URL(fileURLWithPath: "/Users/Horst/MyBase")
        let otherURL = URL(fileURLWithPath: "/Users/Horst/MyBase/./Relative/../Other/Sub")
        
        let result = otherURL.makeRelativeToBaseURL(baseURL)
        
        XCTAssertNotNil(result)
        XCTAssertEqual(baseURL, result?.baseURL)
        XCTAssertEqual("Other/Sub", result?.relativePath)
    }
    
    func testMakeRelativeToURL_OtherURLPointsOutsideBaseURL() {
        let baseURL = URL(fileURLWithPath: "/Users/Johnny")
        let otherURL = URL(fileURLWithPath: "/Users/Johnny/../Allan/Sub")
        
        let result = otherURL.makeRelativeToBaseURL(baseURL)
        
        XCTAssertNil(result)
    }
    
    func testMakeRelativeToURL_BaseAndOtherURLAreIdentical() {
        let baseURL = URL(fileURLWithPath: "/Users/Tom")
        let otherURL = URL(fileURLWithPath: "/Users/Tom")
        
        let result = otherURL.makeRelativeToBaseURL(baseURL)
        
        XCTAssertNil(result)
    }

}






























