//
//  SettingView.swift
//  Morak
//
//  Created by Hong jeongmin on 8/12/25.
//

import SwiftUI

struct SettingView: View {
    @StateObject private var viewModel = SettingViewModel()
    @ObservedObject private var authManager = AuthManager.shared

    // UI State
    @State private var showLogoutAlert: Bool = false
    @State private var showWithdrawAlert: Bool = false
    @State private var showErrorAlert: Bool = false
    @State private var navigateToLogin: Bool = false
    @State private var navigateToMyPosts: Bool = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    // Profile Section
                    profileSection

                    if authManager.isLoggedIn {
                        // Menu Section
                        menuSection
                    }

                    Spacer()
                }
                .padding(.horizontal, 16)
                .padding(.top, 16)
            }
            .background(Color.postBackground.ignoresSafeArea())
            .navigationTitle("설정")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                if authManager.isLoggedIn {
                    Task {
                        await viewModel.fetchMyInfo()
                    }
                }
            }
            .onChange(of: authManager.isLoggedIn) { isLoggedIn in
                if isLoggedIn {
                    Task {
                        await viewModel.fetchMyInfo()
                    }
                } else {
                    viewModel.clearUserInfo()
                }
            }
            .onChange(of: viewModel.errorMessage) { errorMessage in
                if errorMessage != nil {
                    showErrorAlert = true
                }
            }
            .onChange(of: showErrorAlert) { isShowing in
                if !isShowing {
                    viewModel.errorMessage = nil
                }
            }
            .customAlert(
                isPresented: $showLogoutAlert,
                config: CustomAlertConfig(
                    title: "로그아웃",
                    message: "정말 로그아웃하시겠습니까?",
                    primaryButton: AlertButton(title: "로그아웃", style: .destructive) {
                        Task {
                            await viewModel.logout()
                        }
                    },
                    secondaryButton: AlertButton(title: "취소", style: .cancel)
                )
            )
            .customAlert(
                isPresented: $showWithdrawAlert,
                config: CustomAlertConfig(
                    title: "회원탈퇴",
                    message: "정말 탈퇴하시겠습니까?\n탈퇴 시 모든 데이터가 삭제됩니다.",
                    primaryButton: AlertButton(title: "탈퇴", style: .destructive) {
                        // TODO: 회원탈퇴 API 구현
                    },
                    secondaryButton: AlertButton(title: "취소", style: .cancel)
                )
            )
            .customAlert(
                isPresented: $showErrorAlert,
                config: CustomAlertConfig(
                    title: "오류",
                    message: viewModel.errorMessage ?? "알 수 없는 오류가 발생했습니다.",
                    primaryButton: AlertButton(title: "확인", style: .primary)
                )
            )
            .fullScreenCover(isPresented: $navigateToLogin) {
                LoginView()
            }
            .tokenExpirationAlert(isPresented: $viewModel.showTokenExpiredAlert)
            .navigationDestination(isPresented: $navigateToMyPosts) {
                MyPostsView()
            }
        }
    }

    // MARK: - Profile Section
    @ViewBuilder
    private var profileSection: some View {
        VStack(spacing: 0) {
            if authManager.isLoggedIn {
                // 로그인 상태: 유저 정보 표시
                loggedInProfileCard
            } else {
                // 비로그인 상태: 로그인 유도
                loggedOutProfileCard
            }
        }
    }

    private var loggedInProfileCard: some View {
        VStack(spacing: 16) {
            // 프로필 로고
            Image("logo")
                .resizable()
                .scaledToFit()
                .frame(width: 72, height: 72)

            // 유저 정보
            VStack(spacing: 8) {
                if viewModel.isLoading {
                    ProgressView()
                        .frame(height: 40)
                } else {
                    Text(viewModel.nickname ?? "닉네임")
                        .font(.pretendard.largeTextBold)
                        .foregroundColor(.textPrimary)

                    Text(viewModel.email ?? "이메일")
                        .font(.pretendard.mediumTextRegular)
                        .foregroundColor(.textSecondary)
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 24)
        .background(Color.cardBackground)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
    }

    private var loggedOutProfileCard: some View {
        VStack(spacing: 16) {
            // 프로필 로고
            Image("logo")
                .resizable()
                .scaledToFit()
                .frame(width: 72, height: 72)
                .opacity(0.5)

            // 로그인 유도 텍스트
            VStack(spacing: 8) {
                Text("로그인이 필요합니다")
                    .font(.pretendard.largeTextBold)
                    .foregroundColor(.textPrimary)

                Text("로그인하고 모든 기능을 이용해보세요")
                    .font(.pretendard.mediumTextRegular)
                    .foregroundColor(.textSecondary)
            }

            // 로그인 버튼
            Button(action: {
                navigateToLogin = true
            }) {
                Text("로그인")
                    .font(.pretendard.mediumTextSemiBold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 48)
                    .background(Color.main)
                    .cornerRadius(12)
            }
            .padding(.horizontal, 24)
            .padding(.top, 8)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 24)
        .background(Color.cardBackground)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
    }

    // MARK: - Menu Section
    private var menuSection: some View {
        VStack(spacing: 0) {
            // 내가 쓴 게시물
            SettingMenuRow(
                icon: "square.and.pencil",
                title: "내가 쓴 게시물",
                showChevron: true
            ) {
                navigateToMyPosts = true
            }

            Divider()
                .padding(.leading, 52)

            // 로그아웃
            SettingMenuRow(
                icon: "rectangle.portrait.and.arrow.right",
                title: "로그아웃",
                titleColor: .textPrimary,
                showChevron: false
            ) {
                showLogoutAlert = true
            }

            Divider()
                .padding(.leading, 52)

            // 회원탈퇴
            SettingMenuRow(
                icon: "person.slash",
                title: "회원탈퇴",
                titleColor: .error,
                showChevron: false
            ) {
                showWithdrawAlert = true
            }
        }
        .background(Color.cardBackground)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
}

// MARK: - Setting Menu Row
struct SettingMenuRow: View {
    let icon: String
    let title: String
    var titleColor: Color = .textPrimary
    var showChevron: Bool = true
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.system(size: 18))
                    .foregroundColor(.textSecondary)
                    .frame(width: 24)

                Text(title)
                    .font(.pretendard.mediumTextRegular)
                    .foregroundColor(titleColor)

                Spacer()

                if showChevron {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 14))
                        .foregroundColor(.textSecondary)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 16)
        }
    }
}

#Preview {
    SettingView()
}
