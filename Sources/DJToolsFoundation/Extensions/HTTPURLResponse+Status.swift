import Foundation

extension HTTPURLResponse {
    public var hasStatusSuccess: Bool { self.statusCode >= 200 && self.statusCode <= 299 }
    public var hasStatusRedirect: Bool { self.statusCode >= 300 && self.statusCode <= 399 }
    public var hasStatusClientError: Bool { self.statusCode >= 400 && self.statusCode <= 499 }
    public var hasStatusServerError: Bool { self.statusCode >= 500 && self.statusCode <= 599 }
}






























