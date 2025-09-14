//
//  LoginView.swift
//  Morak
//
//  Created by Hong jeongmin on 9/6/25.
//

import SwiftUI

struct LoginView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = LoginViewModel()
    @State private var showSignup: Bool = false
    @FocusState private var focusedField: Field?
    
    enum Field {
        case email
        case password
    }
    
    var body: some View {
        VStack(spacing: 0) {
            HStack() {
                Spacer()
                Button(action: {
                    dismiss()
                }) {
                    Image("ic_close")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .foregroundColor(.secondary)
                }
                .padding()
            }
            .padding(.trailing, 8)
            
            Image("logo")
                .resizable()
                .frame(width: 120, height: 120)
                .padding()
            
            VStack(spacing: 8) {
                Text("환영합니다")
                    .font(.pretendard.largeTitle)
                
                Text("로그인하여 계속하세요")
                    .font(.pretendard.largeTextRegular)
                    .foregroundColor(.secondary)
            }
            .padding(.bottom, 60)
            
            VStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("이메일")
                        .font(.pretendard.mediumTextRegular)
                        .foregroundColor(.secondary)
                    
                    TextField("이메일을 입력하세요", text: $viewModel.email)
                        .textFieldStyle(.plain)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                        .textContentType(.emailAddress)
                        .focused($focusedField, equals: .email)
                        .padding()
                        .background(Color(.systemGray6)) // TODO: 색상 변경
                        .cornerRadius(12)
                        .onSubmit {
                            focusedField = .password
                        }
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("비밀번호")
                        .font(.pretendard.mediumTextRegular)
                        .foregroundColor(.secondary)
                    
                    SecureField("비밀번호를 입력하세요", text: $viewModel.password)
                        .textFieldStyle(.plain)
                        .textContentType(.password)
                        .focused($focusedField, equals: .password)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(viewModel.showError ? Color.customRed : Color.clear, lineWidth: 1)
                        )
                        .onSubmit {
                            Task {
                                await viewModel.login()
                            }
                        }
                        .onChange(of: viewModel.password) { _ in
                            viewModel.clearError()
                        }
                    
                    if viewModel.showError {
                        Text(viewModel.errorMessage)
                            .font(.pretendard.mediumTextRegular)
                            .foregroundColor(.customRed)
                            .padding(.horizontal, 4)
                    }
                }
            }
            .padding(.horizontal, 24)
            
            Spacer()
                .frame(height: 40)
            
            Button(action: {
                Task {
                    await viewModel.login()
                }
            }) {
                HStack {
                    if viewModel.isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .scaleEffect(0.8)
                    }
                    Text(viewModel.isLoading ? "로그인 중..." : "로그인")
                        .font(.pretendard.largeTextMedium)
                        .foregroundColor(.white)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background(
                    Color.accentColor
                        .opacity(viewModel.isFormValid && !viewModel.isLoading ? 1.0 : 0.3)
                )
                .cornerRadius(16)
            }
            .disabled(!viewModel.isFormValid || viewModel.isLoading)
            .padding(.horizontal, 24)
            
            Button(action: handleForgotPassword) {
                Text("비밀번호를 잊으셨나요?")
                    .font(.pretendard.mediumTextRegular)
                    .foregroundColor(.accentColor)
            }
            .padding(.top, 16)
            
            Spacer()
            
            HStack(spacing: 4) {
                Text("아직 계정이 없으신가요?")
                    .font(.pretendard.mediumTextRegular)
                    .foregroundColor(.secondary)
                
                Button {
                    showSignup = true
                } label: {
                    Text("회원가입")
                        .font(.pretendard.mediumTextSemiBold)
                        .fontWeight(.semibold)
                        .foregroundColor(.accentColor)
                }
            }
            .padding(.bottom, 40)
        }
        .onTapGesture {
            focusedField = nil
        }
        .navigationDestination(isPresented: $showSignup) {
            SignupView()
        }
        .onChange(of: viewModel.isLoginSuccessful) { success in
            if success {
                dismiss()
            }
        }
        .onAppear() {
            print(SecureTokenManager.shared.getAccessToken(), "저장된 토큰")
        }
    }
    
    private func handleForgotPassword() {
        // TODO: 비밀번호 찾기 화면으로 이동
        print("비밀번호 찾기")
    }
}

#Preview {
    LoginView()
}
