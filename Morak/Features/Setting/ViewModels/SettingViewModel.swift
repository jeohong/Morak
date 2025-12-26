//
//  SettingViewModel.swift
//  Morak
//
//  Created by Hong jeongmin on 12/26/25.
//

import Foundation

@MainActor
final class SettingViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var email: String?
    @Published var nickname: String?
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    // MARK: - Private Properties
    private let logoutUseCase: LogoutUseCaseProtocol
    // TODO: 내정보 가져오기 UseCase 추가
    // private let getMyInfoUseCase: GetMyInfoUseCaseProtocol

    // MARK: - Init
    init(logoutUseCase: LogoutUseCaseProtocol = LogoutUseCase()) {
        self.logoutUseCase = logoutUseCase
    }

    // MARK: - Public Methods

    /// 내 정보 가져오기
    func fetchMyInfo() async {
        guard !isLoading else { return }

        isLoading = true
        errorMessage = nil

        // TODO: 내정보 가져오기 API 구현
        // do {
        //     let userInfo = try await getMyInfoUseCase.execute()
        //     email = userInfo.email
        //     nickname = userInfo.nickname
        // } catch let error as NetworkError {
        //     if case .tokenRefreshFailed = error {
        //         // 토큰 만료 처리
        //     } else {
        //         errorMessage = error.localizedDescription
        //     }
        // } catch {
        //     errorMessage = "내 정보를 불러오는 중 오류가 발생했습니다."
        // }

        // 임시: AuthManager에서 가져오기 (API 구현 전까지)
        if let user = AuthManager.shared.currentUser {
            email = user.email
            nickname = user.nickname
        }

        isLoading = false
    }

    /// 로그아웃
    func logout() async {
        isLoading = true
        errorMessage = nil

        do {
            try await logoutUseCase.execute()
            clearUserInfo()
        } catch let error as NetworkError {
            errorMessage = error.localizedDescription
        } catch {
            errorMessage = "로그아웃 중 오류가 발생했습니다."
        }

        isLoading = false
    }

    /// 회원탈퇴
    func withdraw() async {
        guard !isLoading else { return }

        isLoading = true
        errorMessage = nil

        // TODO: 회원탈퇴 API 구현
        // do {
        //     try await withdrawUseCase.execute()
        //     clearUserInfo()
        //     AuthManager.shared.logout()
        // } catch let error as NetworkError {
        //     errorMessage = error.localizedDescription
        // } catch {
        //     errorMessage = "회원탈퇴 중 오류가 발생했습니다."
        // }

        isLoading = false
    }

    /// 유저 정보 초기화
    func clearUserInfo() {
        email = nil
        nickname = nil
    }
}
