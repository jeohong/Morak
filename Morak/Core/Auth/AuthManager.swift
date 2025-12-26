//
//  AuthManager.swift
//  Morak
//
//  Created by Hong jeongmin on 11/4/25.
//

import Foundation
import Combine

// MARK: - Application Service Layer
@MainActor
final class AuthManager: ObservableObject {
    static let shared = AuthManager()

    @Published private(set) var isLoggedIn: Bool = false
    @Published private(set) var currentUser: User? = nil

    private init() {
        checkLoginStatus()
    }

    // MARK: - Public Methods

    /// 로그인 상태 확인
    func checkLoginStatus() {
        isLoggedIn = SecureTokenManager.shared.getAccessToken() != nil
    }

    /// 로그인 처리
    func login(accessToken: String, refreshToken: String, user: User) async {
        await SecureTokenManager.shared.saveTokens(
            accessToken: accessToken,
            refreshToken: refreshToken
        )

        currentUser = user
        isLoggedIn = true
    }

    /// 로그아웃 처리
    func logout() {
        SecureTokenManager.shared.clearTokens()

        currentUser = nil
        isLoggedIn = false
    }

    /// 토큰 갱신 처리
    func refreshToken() async throws -> Bool {
        guard let refreshToken = SecureTokenManager.shared.getRefreshToken() else {
            throw NetworkError.unauthorized
        }

        let useCase = RefreshTokenUseCase()
        do {
            _ = try await useCase.execute(refreshToken)
            return true
        } catch {
            // Refresh 실패 시 강제 로그아웃
            logout()
            throw error
        }
    }

    /// Refresh Token 가져오기
    func getRefreshToken() -> String? {
        return SecureTokenManager.shared.getRefreshToken()
    }

    /// Access Token 가져오기
    func getAccessToken() -> String? {
        return SecureTokenManager.shared.getAccessToken()
    }

    /// 로그인 필요 여부 확인
    var requiresLogin: Bool {
        return !isLoggedIn
    }
}
