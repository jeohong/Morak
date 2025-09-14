//
//  SignupView.swift
//  Morak
//
//  Created by Hong jeongmin on 9/11/25.
//

import SwiftUI

struct SignupView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = SignupViewModel()
    @State private var currentStep: SignupStep = .email
    @FocusState private var focusedField: Field?
    
    enum SignupStep {
        case email
        case password
        case nickname
    }
    
    enum Field {
        case email
        case verificationCode
        case password
        case confirmPassword
        case nickname
    }
    
    var body: some View {
        VStack(spacing: 0) {
            HStack() {
                Button(action: {
                    if currentStep == .email {
                        dismiss()
                    } else {
                        goToPreviousStep()
                    }
                }) {
                    Image(systemName: "chevron.left")
                        .resizable()
                        .frame(width: 12, height: 20)
                        .foregroundColor(.secondary)
                }
                .padding()
                
                Spacer()
            }
            .padding(.leading, 8)
            
            ScrollView {
                VStack(spacing: 0) {
                    Image("logo")
                        .resizable()
                        .frame(width: 120, height: 120)
                        .padding()
                    
                    VStack(spacing: 8) {
                        Text(stepTitle)
                            .font(.pretendard.largeTitle)
                        
                        Text(stepSubtitle)
                            .font(.pretendard.largeTextRegular)
                            .foregroundColor(.secondary)
                    }
                    .padding(.bottom, 60)
                    
                    stepContent
                    
                    Spacer()
                        .frame(height: 40)
                    
                    Button(action: handleNextStep) {
                        Text(nextButtonTitle)
                            .font(.pretendard.largeTextMedium)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(
                                Color.accentColor
                                    .opacity(isCurrentStepValid ? 1.0 : 0.3)
                            )
                            .cornerRadius(16)
                    }
                    .disabled(!isCurrentStepValid)
                    .padding(.horizontal, 24)
                    
                    Spacer()
                        .frame(height: 20)
                    
                    HStack(spacing: 4) {
                        Text("이미 계정이 있으신가요?")
                            .font(.pretendard.mediumTextRegular)
                            .foregroundColor(.secondary)
                        
                        Button(action: {
                            dismiss()
                        }) {
                            Text("로그인")
                                .font(.pretendard.mediumTextSemiBold)
                                .fontWeight(.semibold)
                                .foregroundColor(.accentColor)
                        }
                    }
                    .padding(.bottom, 40)
                }
            }
        }
        .onTapGesture {
            focusedField = nil
        }
        .gesture(
            DragGesture()
                .onEnded { value in
                    // 오른쪽으로 스와이프 (뒤로가기)
                    if value.translation.width > 80 && abs(value.translation.height) < 100 {
                        handleSwipeBack()
                    }
                }
        )
        .interactiveDismissDisabled(true)
        .navigationBarHidden(true)
    }
    
    // MARK: - Computed Properties
    
    private var stepTitle: String {
        switch currentStep {
        case .email:
            return "계정 만들기"
        case .password:
            return "비밀번호 설정"
        case .nickname:
            return "닉네임 입력"
        }
    }
    
    private var stepSubtitle: String {
        switch currentStep {
        case .email:
            return "이메일 인증을 완료해주세요"
        case .password:
            return "안전한 비밀번호를 설정해주세요"
        case .nickname:
            return "사용하실 닉네임을 입력해주세요"
        }
    }
    
    private var nextButtonTitle: String {
        switch currentStep {
        case .email, .password:
            return "다음"
        case .nickname:
            return "가입하기"
        }
    }
    
    @ViewBuilder
    private var stepContent: some View {
        VStack(spacing: 16) {
            switch currentStep {
            case .email:
                emailStepContent
            case .password:
                passwordStepContent
            case .nickname:
                nicknameStepContent
            }
        }
        .padding(.horizontal, 24)
        .animation(.easeInOut(duration: 0.3), value: currentStep)
    }
    
    @ViewBuilder
    private var emailStepContent: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("이메일")
                .font(.pretendard.mediumTextRegular)
                .foregroundColor(.secondary)
            
            HStack(spacing: 8) {
                TextField("이메일을 입력하세요", text: $viewModel.email)
                    .textFieldStyle(.plain)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .textContentType(.emailAddress)
                    .focused($focusedField, equals: .email)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    .onSubmit {
                        if viewModel.isEmailSent {
                            focusedField = .verificationCode
                        }
                    }
                
                Button(action: sendVerificationCode) {
                    if viewModel.isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .frame(width: 70, height: 56)
                            .background(Color.accentColor.opacity(0.7))
                            .cornerRadius(12)
                    } else {
                        Text(viewModel.isEmailSent ? "재전송" : "전송")
                            .font(.pretendard.mediumTextSemiBold)
                            .foregroundColor(.white)
                            .frame(width: 70, height: 56)
                            .background(Color.accentColor.opacity(viewModel.isEmailValid && !viewModel.isLoading ? 1.0 : 0.3))
                            .cornerRadius(12)
                    }
                }
                .disabled(!viewModel.isEmailValid || viewModel.isLoading)
            }

            if let emailErrorMessage = viewModel.emailErrorMessage {
                Text(emailErrorMessage)
                    .font(.pretendard.mediumTextRegular)
                    .foregroundColor(.customRed)
                    .padding(.horizontal, 4)
            }
        }

        if viewModel.isEmailSent {
            VStack(alignment: .leading, spacing: 8) {
                Text("인증번호")
                    .font(.pretendard.mediumTextRegular)
                    .foregroundColor(.secondary)
                
                HStack(spacing: 8) {
                    TextField("인증번호를 입력하세요", text: $viewModel.verificationCode)
                        .textFieldStyle(.plain)
                        .keyboardType(.numberPad)
                        .focused($focusedField, equals: .verificationCode)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(viewModel.isCodeVerified ? Color.green : Color.clear, lineWidth: 1)
                        )
                    
                    Button(action: verifyCode) {
                        if viewModel.isLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                .frame(width: 70, height: 56)
                                .background(Color.accentColor.opacity(0.7))
                                .cornerRadius(12)
                        } else {
                            Text("확인")
                                .font(.pretendard.mediumTextSemiBold)
                                .foregroundColor(.white)
                                .frame(width: 70, height: 56)
                                .background(Color.accentColor.opacity(viewModel.verificationCode.isEmpty || viewModel.isLoading ? 0.3 : 1.0))
                                .cornerRadius(12)
                        }
                    }
                    .disabled(viewModel.verificationCode.isEmpty || viewModel.isLoading)
                }

                if let codeErrorMessage = viewModel.codeErrorMessage {
                    Text(codeErrorMessage)
                        .font(.pretendard.mediumTextRegular)
                        .foregroundColor(.customRed)
                        .padding(.horizontal, 4)
                }
            }
        }
    }
    
    @ViewBuilder
    private var passwordStepContent: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("비밀번호")
                .font(.pretendard.mediumTextRegular)
                .foregroundColor(.secondary)
            
            SecureField("비밀번호를 입력하세요", text: $viewModel.password)
                .textFieldStyle(.plain)
                .textContentType(.newPassword)
                .focused($focusedField, equals: .password)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
                .onSubmit {
                    focusedField = .confirmPassword
                }
                .onChange(of: viewModel.password) { _ in
                    if viewModel.showPasswordError {
                        validatePasswords()
                    }
                }
        }
        
        VStack(alignment: .leading, spacing: 8) {
            Text("비밀번호 확인")
                .font(.pretendard.mediumTextRegular)
                .foregroundColor(.secondary)
            
            SecureField("비밀번호를 다시 입력하세요", text: $viewModel.confirmPassword)
                .textFieldStyle(.plain)
                .textContentType(.newPassword)
                .focused($focusedField, equals: .confirmPassword)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(viewModel.showPasswordError ? Color.customRed : Color.clear, lineWidth: 1)
                )
                .onChange(of: viewModel.confirmPassword) { _ in
                    if viewModel.showPasswordError {
                        validatePasswords()
                    }
                }
            
            if viewModel.showPasswordError {
                Text(viewModel.passwordErrorMessage)
                    .font(.pretendard.mediumTextRegular)
                    .foregroundColor(.customRed)
                    .padding(.horizontal, 4)
            }
        }
    }
    
    @ViewBuilder
    private var nicknameStepContent: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("닉네임")
                .font(.pretendard.mediumTextRegular)
                .foregroundColor(.secondary)
            
            TextField("닉네임을 입력하세요", text: $viewModel.nickname)
                .textFieldStyle(.plain)
                .textContentType(.nickname)
                .focused($focusedField, equals: .nickname)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
        }
    }
    
    private var isCurrentStepValid: Bool {
        switch currentStep {
        case .email:
            return viewModel.isEmailValid && viewModel.isCodeVerified
        case .password:
            return viewModel.isPasswordStepValid
        case .nickname:
            return viewModel.isNicknameValid
        }
    }
    
    // MARK: - Methods
    
    private func goToPreviousStep() {
        withAnimation(.easeInOut(duration: 0.3)) {
            switch currentStep {
            case .password:
                currentStep = .email
            case .nickname:
                currentStep = .password
            case .email:
                break
            }
        }
    }
    
    private func handleSwipeBack() {
        if currentStep == .email {
            dismiss()
        } else {
            goToPreviousStep()
        }
    }
    
    private func handleNextStep() {
        switch currentStep {
        case .email:
            if isCurrentStepValid {
                withAnimation(.easeInOut(duration: 0.3)) {
                    currentStep = .password
                }
                focusedField = .password
            }
        case .password:
            validatePasswords()
            if !viewModel.showPasswordError && isCurrentStepValid {
                withAnimation(.easeInOut(duration: 0.3)) {
                    currentStep = .nickname
                }
                focusedField = .nickname
            }
        case .nickname:
            if isCurrentStepValid {
                handleSignUp()
            }
        }
    }
    
    private func validatePasswords() {
        viewModel.validatePasswords()
    }
    
    private func sendVerificationCode() {
        guard viewModel.isEmailValid else { return }

        Task {
            await viewModel.checkAndSendEmail()

            if viewModel.isEmailSent {
                focusedField = .verificationCode
            }
        }
    }
    
    private func verifyCode() {
        guard !viewModel.verificationCode.isEmpty else { return }

        Task {
            await viewModel.verifyEmailCode()

            if viewModel.isCodeVerified {
                withAnimation(.easeInOut(duration: 0.3)) {
                    currentStep = .password
                }
                focusedField = .password
            }
        }
    }
    
    private func handleSignUp() {
        focusedField = nil
        
        // TODO: 실제 API 통신 로직 구현
        print("회원가입 시도: \(viewModel.email), 닉네임: \(viewModel.nickname)")
        
        // 회원가입 성공 시 화면 닫기
        dismiss()
    }
}

#Preview {
    SignupView()
}
