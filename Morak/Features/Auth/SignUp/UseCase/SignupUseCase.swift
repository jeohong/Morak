//
//  SignupUseCase.swift
//  Morak
//
//  Created by Hong jeongmin on 9/14/25.
//

import Foundation

protocol SignupUseCaseProtocol {
    func checkEmail(_ email: String) async throws -> EmailCheckResponse
    func sendVerificationEmail(_ email: String) async throws -> EmailSendResponse
    func verifyEmail(_ email: String, code: String) async throws -> EmailVerifyResponse
    func checkEmailAndSendVerification(_ email: String) async throws
    func verifyEmailCode(_ email: String, code: String) async throws
}

final class SignupUseCase: SignupUseCaseProtocol {
    private let emailRepository: EmailRepositoryProtocol

    init(emailRepository: EmailRepositoryProtocol = EmailRepository()) {
        self.emailRepository = emailRepository
    }

    func checkEmail(_ email: String) async throws -> EmailCheckResponse {
        let request = EmailCheckRequest(email: email)
        return try await emailRepository.checkEmail(request)
    }

    func sendVerificationEmail(_ email: String) async throws -> EmailSendResponse {
        let request = EmailSendRequest(email: email)
        return try await emailRepository.sendEmail(request)
    }

    func verifyEmail(_ email: String, code: String) async throws -> EmailVerifyResponse {
        let request = EmailVerifyRequest(email: email, code: code)
        return try await emailRepository.verifyEmail(request)
    }

    // MARK: - Business Logic Methods

    func checkEmailAndSendVerification(_ email: String) async throws {
        // 1. 이메일 유효성 검사
        guard !email.isEmpty, email.contains("@"), email.contains(".") else {
            throw SignupError.invalidEmailFormat
        }

        do {
            // 2. 이메일 중복 확인
            let checkResponse = try await checkEmail(email)

            if checkResponse.data == false {
                throw SignupError.emailAlreadyExists
            }

            // 3. 인증 이메일 전송
            _ = try await sendVerificationEmail(email)

        } catch SignupError.emailAlreadyExists {
            throw SignupError.emailAlreadyExists
        } catch {
            if error.localizedDescription.contains("확인") {
                throw SignupError.emailCheckFailed
            } else {
                throw SignupError.emailSendFailed
            }
        }
    }

    func verifyEmailCode(_ email: String, code: String) async throws {
        guard !code.isEmpty else {
            throw SignupError.emptyVerificationCode
        }

        do {
            _ = try await verifyEmail(email, code: code)
        } catch {
            throw SignupError.invalidVerificationCode
        }
    }
}

// MARK: - Error Types

enum SignupError: Error, LocalizedError {
    case invalidEmailFormat
    case emailAlreadyExists
    case emailCheckFailed
    case emailSendFailed
    case emptyVerificationCode
    case invalidVerificationCode

    var errorDescription: String? {
        switch self {
        case .invalidEmailFormat:
            return "올바른 이메일 형식이 아닙니다"
        case .emailAlreadyExists:
            return "이미 가입된 이메일입니다"
        case .emailCheckFailed:
            return "이메일 확인 중 오류가 발생했습니다"
        case .emailSendFailed:
            return "이메일 전송 중 오류가 발생했습니다"
        case .emptyVerificationCode:
            return "인증번호를 입력해주세요"
        case .invalidVerificationCode:
            return "인증번호가 올바르지 않습니다"
        }
    }
}