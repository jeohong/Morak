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
    @Published var showTokenExpiredAlert: Bool = false
    @Published var showWithdrawSuccessAlert: Bool = false

    // MARK: - Private Properties
    private let logoutUseCase: LogoutUseCaseProtocol
    private let getMyInfoUseCase: GetMyInfoUseCaseProtocol
    private let withdrawUseCase: WithdrawUseCaseProtocol

    // MARK: - Init
    init(
        logoutUseCase: LogoutUseCaseProtocol = LogoutUseCase(),
        getMyInfoUseCase: GetMyInfoUseCaseProtocol = GetMyInfoUseCase.makeDefault(),
        withdrawUseCase: WithdrawUseCaseProtocol = WithdrawUseCase.makeDefault()
    ) {
        self.logoutUseCase = logoutUseCase
        self.getMyInfoUseCase = getMyInfoUseCase
        self.withdrawUseCase = withdrawUseCase
    }

    // MARK: - Public Methods

    /// 내 정보 가져오기
    func fetchMyInfo() async {
        guard !isLoading else { return }

        isLoading = true
        errorMessage = nil

        do {
            let myInfo = try await getMyInfoUseCase.execute()
            email = myInfo.email
            nickname = myInfo.nickname
        } catch let error as NetworkError {
            if case .tokenRefreshFailed = error {
                showTokenExpiredAlert = true
            } else {
                errorMessage = error.localizedDescription
            }
        } catch {
            errorMessage = "내 정보를 불러오는 중 오류가 발생했습니다."
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

        do {
            _ = try await withdrawUseCase.execute()
            // 성공 시 모든 저장 정보 삭제
            clearUserInfo()
            SecureTokenManager.shared.clearTokens()
            AuthManager.shared.logout()
            showWithdrawSuccessAlert = true
        } catch let error as NetworkError {
            if case .tokenRefreshFailed = error {
                showTokenExpiredAlert = true
            } else {
                errorMessage = error.localizedDescription
            }
        } catch {
            errorMessage = "회원탈퇴 중 오류가 발생했습니다."
        }

        isLoading = false
    }

    /// 유저 정보 초기화
    func clearUserInfo() {
        email = nil
        nickname = nil
    }
}
