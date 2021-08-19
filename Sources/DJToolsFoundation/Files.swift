import Foundation
import Combine
import DJToolsSwift






/**
 Easily list, explore and handle files
 */
public class Files {
    
    // MARK: - Default-Instance
    
    public static let `default`: Files = Files()
    
    
    
    
    
    // MARK: - API
    
    public func listFiles(in url: URL, options: Files.ListOption...) throws -> [URL] {
        return try listFiles(in: url, options: options)
    }
    
    public func listFilesAsync(in url: URL, options: Files.ListOption...) -> AnyPublisher<[URL], Error> {
        return Future { [weak self] promise in
            guard let weakSelf = self else {
                promise(.failure(Error.listFilesFailed(underlyingError: nil, debugMessage: "Self was nil")))
                return
            }
            
            weakSelf.dispatchQueue.async {
                do {
                    let result = try weakSelf.listFiles(in: url, options: options)
                    promise(.success(result))
                } catch let error as Error {
                    promise(.failure(error))
                } catch let error {
                    promise(.failure(Error.listFilesFailed(underlyingError: error, debugMessage: nil)))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    
    
    
    
    // MARK: - Subtypes
    
    public enum ListOption {
        case files
        case directories
        case recursively
        case hidden
        case makeURLsRelativeToURL
    }
    
    public enum Error: DJError {
        case listFilesFailed(underlyingError: Swift.Error?, debugMessage: String?)
        
        public var underlyingError: Swift.Error? {
            switch self {
            case let .listFilesFailed(underlyingError: error, debugMessage: _): return error
            }
        }
        
        public var debugMessage: String? {
            switch self {
            case let .listFilesFailed(underlyingError: _, debugMessage: debugMessage): return debugMessage
            }
        }
    }
    
    
    
    
    
    // MARK: - Privaate
    
    private let fileIO: FileManager = FileManager()
    private let dispatchQueue: DispatchQueue = DispatchQueue(label: "de.drjackyl.djtools.djfiles")
    
    private func listFiles(in url: URL, options: [Files.ListOption]) throws -> [URL] {
        do {
            let includeFiles = options.contains(.files)
            let includeDirectories = options.contains(.directories)
            let includeHidden = options.contains(.hidden)
            let recursively = options.contains(.recursively)
            let makeRelative = options.contains(.makeURLsRelativeToURL)
            
            var resourceKeys: [URLResourceKey] = [.isHiddenKey]
            if includeFiles { resourceKeys.append(.isRegularFileKey) }
            if includeDirectories { resourceKeys.append(.isDirectoryKey) }
            
            guard let enumerator = fileIO.enumerator(at: url, includingPropertiesForKeys: resourceKeys) else {
                throw Error.listFilesFailed(underlyingError: nil, debugMessage: "Failed to create enumerator for URL '\(url.absoluteString)'")
            }
            
            var result: [URL] = []
            try enumerator.forEach { object in
                guard let childURL = object as? URL else { return }
                
                let resourceValues = try childURL.resourceValues(forKeys: [.isHiddenKey, .isRegularFileKey, .isDirectoryKey])
                let isHidden = resourceValues.isHidden ?? false
                let isFile = resourceValues.isRegularFile ?? false
                let isDirectory = resourceValues.isDirectory ?? false
                
                if isDirectory && !recursively {
                    enumerator.skipDescendants()
                }
                
                if isHidden {
                    if !includeHidden { return }
                }
                
                if isFile && includeFiles {
                    if makeRelative {
                        guard let relativeURL = childURL.makeRelativeToBaseURL(url) else {
                            throw Error.listFilesFailed(underlyingError: nil, debugMessage: "Failed to make child-URL '\(childURL.absoluteString)' relative to URL '\(url.absoluteString)'")
                        }
                        result.append(relativeURL)
                        return
                    } else {
                        result.append(childURL)
                        return
                    }
                }
                
                if isDirectory && includeDirectories {
                    if makeRelative {
                        guard let relativeURL = childURL.makeRelativeToBaseURL(url) else {
                            throw Error.listFilesFailed(underlyingError: nil, debugMessage: "Failed to make child-URL '\(childURL.absoluteString)' relative to URL '\(url.absoluteString)'")
                        }
                        result.append(relativeURL)
                        return
                    } else {
                        result.append(childURL)
                        return
                    }
                }
            }
            return result
        } catch let error as Error {
            throw error
        } catch let error {
            throw Error.listFilesFailed(underlyingError: error, debugMessage: "An error in the underlying logic occurred")
        }
    }
}








































