//
//  LoginView.swift
//  Morak
//
//  Created by Hong jeongmin on 9/6/25.
//

import SwiftUI

struct LoginView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var showPasswordError: Bool = false
    @State private var passwordErrorMessage: String = ""
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
                    
                    TextField("이메일을 입력하세요", text: $email)
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
                    
                    SecureField("비밀번호를 입력하세요", text: $password)
                        .textFieldStyle(.plain)
                        .textContentType(.password)
                        .focused($focusedField, equals: .password)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(showPasswordError ? Color.customRed : Color.clear, lineWidth: 1)
                        )
                        .onSubmit {
                            handleLogin()
                        }
                        .onChange(of: password) { _ in
                            if showPasswordError {
                                showPasswordError = false
                                passwordErrorMessage = ""
                            }
                        }
                    
                    if showPasswordError {
                        Text(passwordErrorMessage)
                            .font(.pretendard.mediumTextRegular)
                            .foregroundColor(.customRed)
                            .padding(.horizontal, 4)
                    }
                }
            }
            .padding(.horizontal, 24)
            
            Spacer()
                .frame(height: 40)
            
            Button(action: handleLogin) {
                Text("로그인")
                    .font(.pretendard.largeTextMedium)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .background(
                        Color.accentColor
                            .opacity(isFormValid ? 1.0 : 0.3)
                    )
                    .cornerRadius(16)
            }
            .disabled(!isFormValid)
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
    }
    
    private var isFormValid: Bool {
        !email.isEmpty && email.contains("@") && !password.isEmpty && password.count >= 6
    }
    
    private func handleLogin() {
        guard isFormValid else { return }
        focusedField = nil
        
        // TODO: 실제 API 통신 로직 구현
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            // 로그인 실패 시뮬레이션
            showPasswordError = true
            passwordErrorMessage = "비밀번호가 일치하지 않습니다."
        }
        
        print("로그인 시도: \(email)")
    }
    
    private func handleForgotPassword() {
        // TODO: 비밀번호 찾기 화면으로 이동
        print("비밀번호 찾기")
    }
}

#Preview {
    LoginView()
}
