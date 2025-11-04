//
//  LoginUseCase.swift
//  Morak
//
//  Created by Hong jeongmin on 9/12/25.
//

import Foundation

protocol LoginUseCaseProtocol {
    func execute(_ request: LoginRequest) async throws -> LoginData
}

final class LoginUseCase: LoginUseCaseProtocol {
    private let repository: AuthRepositoryProtocol
    
    init(repository: AuthRepositoryProtocol = AuthRepository()) {
        self.repository = repository
    }
    
    func execute(_ request: LoginRequest) async throws -> LoginData {
        guard !request.email.isEmpty else {
            throw ValidationError.emptyEmail
        }

        guard request.email.contains("@") else {
            throw ValidationError.invalidEmailFormat
        }

        guard !request.password.isEmpty else {
            throw ValidationError.emptyPassword
        }

        guard request.password.count >= 6 else {
            throw ValidationError.passwordTooShort
        }

        let response = try await repository.login(request)

        let user = User(
            id: String(response.data.id),
            email: response.data.email,
            nickname: response.data.nickname
        )

        await AuthManager.shared.login(
            accessToken: response.data.accessToken,
            refreshToken: response.data.refreshToken,
            user: user
        )

        return response.data
    }
}

enum ValidationError: Error, LocalizedError {
    case emptyEmail
    case invalidEmailFormat
    case emptyPassword
    case passwordTooShort
    
    var errorDescription: String? {
        switch self {
        case .emptyEmail:
            return "이메일을 입력해주세요."
        case .invalidEmailFormat:
            return "올바른 이메일 형식이 아닙니다."
        case .emptyPassword:
            return "비밀번호를 입력해주세요."
        case .passwordTooShort:
            return "비밀번호는 영어, 숫자, 특수문자를 포함하며 8자 이상 20자 이하여야 합니다."
        }
    }
}
