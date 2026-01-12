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

    private let userDefaultsKey = "currentUser"

    private init() {
        restoreUser()
        checkLoginStatus()
    }

    // MARK: - Private Methods

    /// UserDefaults에서 사용자 정보 복원
    private func restoreUser() {
        if let data = UserDefaults.standard.data(forKey: userDefaultsKey),
           let user = try? JSONDecoder().decode(User.self, from: data) {
            currentUser = user
        }
    }

    /// UserDefaults에 사용자 정보 저장
    private func saveUser(_ user: User) {
        if let data = try? JSONEncoder().encode(user) {
            UserDefaults.standard.set(data, forKey: userDefaultsKey)
        }
    }

    /// UserDefaults에서 사용자 정보 삭제
    private func clearSavedUser() {
        UserDefaults.standard.removeObject(forKey: userDefaultsKey)
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
        saveUser(user)
        isLoggedIn = true
    }

    /// 로그아웃 처리
    func logout() {
        SecureTokenManager.shared.clearTokens()
        clearSavedUser()

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
