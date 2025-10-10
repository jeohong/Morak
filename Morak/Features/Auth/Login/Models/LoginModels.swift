//
//  LoginModels.swift
//  Morak
//
//  Created by Hong jeongmin on 9/12/25.
//

import Foundation

// MARK: - 로그인 요청/응답 모델

struct LoginRequest: Codable {
    let email: String
    let password: String
}

struct LoginData: Codable {
    let id: Int
    let email: String
    let nickname: String
    let loginType: String
    let role: String
    let accessToken: String
    let refreshToken: String
}