import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

public extension NetworkClient.Configs {
    
    var isAuthEnabled: Bool {
        get { self[\.isAuthEnabled] ?? false }
        set { self[\.isAuthEnabled] = newValue }
    }
}

public extension NetworkClient {
    
    func auth(_ authModifier: AuthModifier) -> NetworkClient {
        enableAuth().modifyRequest { request, configs in
            if configs.isAuthEnabled {
                try authModifier.modifier(&request)
            }
        }
    }
    
    func disableAuth() -> NetworkClient {
        enableAuth(false)
    }
    
    func enableAuth(_ enabled: Bool = true) -> NetworkClient {
        configs(\.isAuthEnabled, enabled)
    }
}
