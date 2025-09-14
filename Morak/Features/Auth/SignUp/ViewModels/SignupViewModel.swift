//
//  SignupViewModel.swift
//  Morak
//
//  Created by Hong jeongmin on 9/14/25.
//

import Foundation
import Combine

@MainActor
final class SignupViewModel: ObservableObject {
    // Text field states
    @Published var email: String = ""
    @Published var verificationCode: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""
    @Published var nickname: String = ""

    // UI states
    @Published var isLoading: Bool = false
    @Published var emailErrorMessage: String?
    @Published var codeErrorMessage: String?
    @Published var passwordErrorMessage: String = ""
    @Published var showPasswordError: Bool = false
    @Published var isEmailAlreadyExists: Bool = false
    @Published var isEmailSent: Bool = false
    @Published var isCodeVerified: Bool = false

    private let signupUseCase: SignupUseCaseProtocol
    private var cancellables = Set<AnyCancellable>()

    init(signupUseCase: SignupUseCaseProtocol = SignupUseCase()) {
        self.signupUseCase = signupUseCase
    }

    // MARK: - Computed Properties

    var isEmailValid: Bool {
        !email.isEmpty && email.contains("@") && email.contains(".")
    }

    var isPasswordStepValid: Bool {
        !password.isEmpty && password.count >= 6 && password == confirmPassword
    }

    var isNicknameValid: Bool {
        !nickname.isEmpty
    }

    func checkAndSendEmail() async {
        guard isEmailValid else { return }

        isLoading = true
        emailErrorMessage = nil
        codeErrorMessage = nil
        isEmailAlreadyExists = false

        do {
            try await signupUseCase.checkEmailAndSendVerification(email)
            isEmailSent = true
            emailErrorMessage = nil
        } catch SignupError.emailAlreadyExists {
            isEmailAlreadyExists = true
            emailErrorMessage = "이미 가입된 이메일입니다"
        } catch SignupError.emailCheckFailed {
            emailErrorMessage = "이메일 확인 중 오류가 발생했습니다"
        } catch SignupError.emailSendFailed {
            emailErrorMessage = "이메일 전송 중 오류가 발생했습니다"
        } catch {
            emailErrorMessage = "알 수 없는 오류가 발생했습니다"
        }

        isLoading = false
    }

    func verifyEmailCode() async {
        guard !verificationCode.isEmpty else { return }

        isLoading = true
        codeErrorMessage = nil

        do {
            try await signupUseCase.verifyEmailCode(email, code: verificationCode)
            isCodeVerified = true
            codeErrorMessage = nil
        } catch SignupError.invalidVerificationCode {
            codeErrorMessage = "인증번호가 올바르지 않습니다"
            isCodeVerified = false
        } catch {
            codeErrorMessage = "인증번호 확인 중 오류가 발생했습니다"
            isCodeVerified = false
        }

        isLoading = false
    }

    func validatePasswords() {
        if !confirmPassword.isEmpty && password != confirmPassword {
            showPasswordError = true
            passwordErrorMessage = "비밀번호가 일치하지 않습니다."
        } else {
            showPasswordError = false
            passwordErrorMessage = ""
        }
    }

    func resetState() {
        isLoading = false
        emailErrorMessage = nil
        codeErrorMessage = nil
        isEmailAlreadyExists = false
        isEmailSent = false
        isCodeVerified = false
    }
}
