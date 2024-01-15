import Foundation
import SwiftNetworking

protocol TokenCacheService {
    
    func saveToken(_ token: String)
    func getToken() -> String?
    func clearToken()
}

extension NetworkClient {
    
    func beaerAuth(_ service: TokenCacheService) -> NetworkClient {
        auth(
            AuthModifier { request in
                guard let token = service.getToken() else {
                    throw NoToken()
                }
                request.setHeader(.authorization(bearerToken: token))
            }
        )
    }
}

struct UserDefaultsTokenCacheService: TokenCacheService {
    
    // Key used to store the token in UserDefaults
    private let tokenKey = "APIToken"
    
    // UserDefaults instance for data storage
    private let defaults: UserDefaults
    
    // Initializer allowing injection of UserDefaults instance for flexibility and testability
    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }
    
    // Function to save the API token
    func saveToken(_ token: String) {
        defaults.set(token, forKey: tokenKey)
    }
    
    // Function to retrieve the API token
    func getToken() -> String? {
        return defaults.string(forKey: tokenKey)
    }
    
    // Function to clear the API token
    func clearToken() {
        defaults.removeObject(forKey: tokenKey)
    }
}

final class MockTokenCacheService: TokenCacheService {
    
    private var token: String?
    
    static let shared = MockTokenCacheService()
    
    func saveToken(_ token: String) {
        self.token = token
    }
    
    func getToken() -> String? {
        token
    }
    
    func clearToken() {
        token = nil
    }
}

private struct NoToken: Error {}
