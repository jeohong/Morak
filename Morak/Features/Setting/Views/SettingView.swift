//
//  SettingView.swift
//  Morak
//
//  Created by Hong jeongmin on 8/12/25.
//

import SwiftUI

struct SettingView: View {
    @StateObject private var logoutViewModel = LogoutViewModel()
    @State private var showLogoutAlert = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("세팅 뷰")
                    .font(.largeTitle)
                
                Spacer()
                
                // TODO: (임시) 사용자 정보 표시
                if let userEmail = UserDefaults.standard.string(forKey: "user_email"),
                   let userId = UserDefaults.standard.string(forKey: "user_id"),
                   let userNickname = UserDefaults.standard.string(forKey: "user_nickname") {
                    VStack(spacing: 8) {
                        Text("로그인된 사용자")
                            .font(.headline)
                        Text("이메일: \(userEmail)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Text("유저아이디: \(userId)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Text("닉네임: \(userNickname)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    .padding(.horizontal)
                }
                
                Spacer()
                
                // 로그아웃 버튼
                Button(action: {
                    showLogoutAlert = true
                }) {
                    HStack {
                        if logoutViewModel.isLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                .scaleEffect(0.8)
                        }
                        Text(logoutViewModel.isLoading ? "로그아웃 중..." : "로그아웃")
                            .font(.headline)
                            .foregroundColor(.white)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .background(Color.red)
                    .cornerRadius(16)
                }
                .disabled(logoutViewModel.isLoading)
                .padding(.horizontal)
                .padding(.bottom, 50)
            }
            .navigationTitle("설정")
            .alert("로그아웃", isPresented: $showLogoutAlert) {
                Button("취소", role: .cancel) { }
                Button("로그아웃", role: .destructive) {
                    Task {
                        await logoutViewModel.logout()
                    }
                }
            } message: {
                Text("정말 로그아웃하시겠습니까?")
            }
            .alert("로그아웃 오류", isPresented: $logoutViewModel.showError) {
                Button("확인") {
                    logoutViewModel.clearError()
                }
            } message: {
                Text(logoutViewModel.errorMessage)
            }
            .onChange(of: logoutViewModel.isLogoutSuccessful) { success in
                if success {
                    // TODO: 로그인 화면으로 이동하거나 앱 상태 리셋
                    print("로그아웃 완료 - 로그인 화면으로 이동 필요")
                }
            }
        }
    }
}

#Preview {
    SettingView()
}
