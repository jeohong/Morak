//
//  EmailRepository.swift
//  Morak
//
//  Created by Hong jeongmin on 9/14/25.
//

import Foundation

protocol EmailRepositoryProtocol {
    func checkEmail(_ request: EmailCheckRequest) async throws -> EmailCheckResponse
    func sendEmail(_ request: EmailSendRequest) async throws -> EmailSendResponse
    func verifyEmail(_ request: EmailVerifyRequest) async throws -> EmailVerifyResponse
}

final class EmailRepository: EmailRepositoryProtocol {
    private let apiManager: APIManagerProtocol

    init(apiManager: APIManagerProtocol = APIManager.shared) {
        self.apiManager = apiManager
    }

    func checkEmail(_ request: EmailCheckRequest) async throws -> EmailCheckResponse {
        let endpoint = EmailEndpoint.checkEmail(request)
        return try await apiManager.request(endpoint, responseType: EmailCheckResponse.self)
    }

    func sendEmail(_ request: EmailSendRequest) async throws -> EmailSendResponse {
        let endpoint = EmailEndpoint.sendEmail(request)
        return try await apiManager.request(endpoint, responseType: EmailSendResponse.self)
    }

    func verifyEmail(_ request: EmailVerifyRequest) async throws -> EmailVerifyResponse {
        let endpoint = EmailEndpoint.verifyEmail(request)
        return try await apiManager.request(endpoint, responseType: EmailVerifyResponse.self)
    }
}