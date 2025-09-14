//
//  SignupModels.swift
//  Morak
//
//  Created by Hong jeongmin on 9/14/25.
//

import Foundation

// MARK: - 이메일 체크 요청/응답 모델

struct EmailCheckRequest: Codable {
    let email: String
}

struct EmailCheckResponse: Codable {
    let message: String
    let data: Bool
}

// MARK: - 이메일 전송 요청/응답 모델

struct EmailSendRequest: Codable {
    let email: String
}

struct EmailSendResponse: Codable {
    let message: String
    let data: Bool?
}

// MARK: - 이메일 인증번호 확인 요청/응답 모델

struct EmailVerifyRequest: Codable {
    let email: String
    let code: String
}

struct EmailVerifyResponse: Codable {
    let message: String
    let data: Bool?
}