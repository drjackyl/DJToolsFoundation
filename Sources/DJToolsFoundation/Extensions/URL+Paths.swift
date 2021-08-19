import Foundation

extension URL {
    
    /**
     Determines, whether self has the given base-URL, even if it was not created with the respective argument.
     */
    public func hasBaseURL(_ baseURL: URL) -> Bool {
        if self.baseURL == baseURL { return true }
        
        return self.absoluteString.hasPrefix(baseURL.absoluteString)
    }
    
    /**
     Returns a URL relative to the given base-URL, so the path within the base-URL can be accessed via URL.relativePath.
     
     The URL is checked against the base-URL by prefix-checking the standardized absolute string of both. That means, the comparison includes the scheme and
     authority, if present.
     
     ## No escaping
     
     By standardizing both URLs prior to prefix-checking, self cannot escape the base-URL, ie. must be a child of base-URL.
     
     ```
     let baseURL = URL(fileURLWithPath: "/Users/Johnny")
     let otherURL = URL(fileURLWithPath: "/Users/Johnny/../Allan/Sub")
     let result = otherURL.makeRelativeToBaseURL(baseURL)
     XCTAssertNil(result)
     ```
     */
    public func makeRelativeToBaseURL(_ baseURL: URL) -> URL? {
        let baseURL = baseURL.standardized
        let baseURLString = baseURL.absoluteString
        let urlString = self.standardized.absoluteString
        guard urlString.hasPrefix(baseURLString) else { return nil }
        
        let relativePathSubSequence = urlString.dropFirst(baseURLString.count)
        if let firstCharacter = relativePathSubSequence.first, firstCharacter == "/" {
            let normalizedRelativePath = String(relativePathSubSequence.dropFirst())
            return URL(string: normalizedRelativePath, relativeTo: baseURL)
        } else {
            return URL(string: String(relativePathSubSequence), relativeTo: baseURL)
        }
    }
    
}






























