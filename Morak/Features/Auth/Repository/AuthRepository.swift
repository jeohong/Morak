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
    func signup(_ request: SignupRequest) async throws -> BaseResponse<SignupData>
    func refresh(_ request: RefreshTokenRequest) async throws -> BaseResponse<RefreshTokenData>
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

    func signup(_ request: SignupRequest) async throws -> BaseResponse<SignupData> {
        let endpoint = AuthEndpoint.signup(request)
        return try await apiManager.request(endpoint, responseType: BaseResponse<SignupData>.self)
    }

    func refresh(_ request: RefreshTokenRequest) async throws -> BaseResponse<RefreshTokenData> {
        let endpoint = AuthEndpoint.refresh(request)
        return try await apiManager.request(endpoint, responseType: BaseResponse<RefreshTokenData>.self)
    }
}
