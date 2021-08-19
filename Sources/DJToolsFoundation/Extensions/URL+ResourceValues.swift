import Foundation

extension URL {
    
    /**
     A save convenience-property to access the resource-value for `URLResourceKey.isRegularFileKey`.
     
     Errors are swallowed and nil is returned instead.
     */
    public var resourceValueIsRegularFile: Bool? {
        let resourceValues = try? self.resourceValues(forKeys: [URLResourceKey.isRegularFileKey])
        return resourceValues?.isRegularFile
    }
    
    /**
     A save convenience-property to access the resource-value for `URLResourceKey.isDirectory`.
     
     Errors are swallowed and nil is returned instead.
     */
    public var resourceValueIsDirectory: Bool? {
        let resourceValues = try? self.resourceValues(forKeys: [URLResourceKey.isDirectoryKey])
        return resourceValues?.isDirectory
    }
    
    /**
     A save convenience-property to access the resource-value for `URLResourceKey.isHidden`.
     
     Errors are swallowed and nil is returned instead.
     */
    public var resourceValueIsHidden: Bool? {
        let resourceValues = try? self.resourceValues(forKeys: [URLResourceKey.isHiddenKey])
        return resourceValues?.isHidden
    }
    
}






























