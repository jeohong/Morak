//
//  UserSearchDTO.swift
//  Morak
//
//  Created by Hong jeongmin on 12/23/25.
//

import Foundation

// MARK: - User Search DTO
struct UserSearchDTO: Codable {
    let id: Int
    let email: String
    let nickname: String
    let loginType: String
    let role: String
    let accessToken: String?
    let refreshToken: String?
}
