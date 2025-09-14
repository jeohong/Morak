//
//  AuthRepository.swift
//  Morak
//
//  Created by Hong jeongmin on 9/12/25.
//


import Foundation

protocol AuthRepositoryProtocol {
    func login(_ request: LoginRequest) async throws -> BaseResponse<LoginData>
    func logout() async throws -> LogoutResponse
}

final class AuthRepository: AuthRepositoryProtocol {
    private let apiManager: APIManagerProtocol
    
    init(apiManager: APIManagerProtocol = APIManager.shared) {
        self.apiManager = apiManager
    }
    
    func login(_ request: LoginRequest) async throws -> BaseResponse<LoginData> {
        let endpoint = AuthEndpoint.login(request)
        return try await apiManager.request(endpoint, responseType: BaseResponse<LoginData>.self)
    }
    
    func logout() async throws -> LogoutResponse {
        let endpoint = AuthEndpoint.logout
        return try await apiManager.request(endpoint, responseType: LogoutResponse.self)
    }
}
