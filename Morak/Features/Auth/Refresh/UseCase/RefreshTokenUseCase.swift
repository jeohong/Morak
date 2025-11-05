//
//  RefreshTokenUseCase.swift
//  Morak
//
//  Created by Hong jeongmin on 11/5/25.
//

import Foundation

protocol RefreshTokenUseCaseProtocol {
    func execute(_ refreshToken: String) async throws -> RefreshTokenData
}

final class RefreshTokenUseCase: RefreshTokenUseCaseProtocol {
    private let repository: AuthRepositoryProtocol

    init(repository: AuthRepositoryProtocol = AuthRepository()) {
        self.repository = repository
    }

    func execute(_ refreshToken: String) async throws -> RefreshTokenData {
        let request = RefreshTokenRequest(refreshToken: refreshToken)
        let response = try await repository.refresh(request)

        // 새로운 토큰으로 AuthManager 업데이트
        let user = User(
            id: String(response.data.id),
            email: response.data.email,
            nickname: response.data.nickname
        )

        await AuthManager.shared.login(
            accessToken: response.data.accessToken,
            refreshToken: response.data.refreshToken,
            user: user
        )

        return response.data
    }
}
