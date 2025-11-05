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

    private let userIdKey = "user_id"
    private let userEmailKey = "user_email"
    private let userNicknameKey = "user_nickname"

    private init() {
        checkLoginStatus()
        loadUserInfo()
    }

    // MARK: - Public Methods

    /// 로그인 상태 확인
    func checkLoginStatus() {
        isLoggedIn = SecureTokenManager.shared.getAccessToken() != nil
    }

    /// UserDefaults에서 사용자 정보 로드
    private func loadUserInfo() {
        guard let id = UserDefaults.standard.string(forKey: userIdKey),
              let email = UserDefaults.standard.string(forKey: userEmailKey),
              let nickname = UserDefaults.standard.string(forKey: userNicknameKey) else {
            currentUser = nil
            return
        }

        currentUser = User(id: id, email: email, nickname: nickname)
    }

    /// 로그인 처리
    func login(accessToken: String, refreshToken: String, user: User) async {
        await SecureTokenManager.shared.saveTokens(
            accessToken: accessToken,
            refreshToken: refreshToken
        )

        // 사용자 정보 저장
        UserDefaults.standard.set(user.id, forKey: userIdKey)
        UserDefaults.standard.set(user.email, forKey: userEmailKey)
        UserDefaults.standard.set(user.nickname, forKey: userNicknameKey)
        UserDefaults.standard.synchronize()

        currentUser = user
        isLoggedIn = true
    }

    /// 로그아웃 처리
    func logout() {
        SecureTokenManager.shared.clearTokens()

        // 사용자 정보 삭제
        UserDefaults.standard.removeObject(forKey: userIdKey)
        UserDefaults.standard.removeObject(forKey: userEmailKey)
        UserDefaults.standard.removeObject(forKey: userNicknameKey)
        UserDefaults.standard.synchronize()

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
