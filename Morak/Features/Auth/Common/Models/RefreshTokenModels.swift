//
//  RefreshTokenModels.swift
//  Morak
//
//  Created by Hong jeongmin on 11/5/25.
//

import Foundation

// MARK: - Refresh Token 요청/응답 모델

struct RefreshTokenRequest: Codable {
    let refreshToken: String
}

struct RefreshTokenData: Codable {
    let id: Int
    let email: String
    let nickname: String
    let loginType: String
    let role: String
    let accessToken: String
    let refreshToken: String
}
