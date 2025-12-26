//
//  MyInfoDTO.swift
//  Morak
//
//  Created by Hong jeongmin on 12/26/25.
//

import Foundation

struct MyInfoDTO: Codable {
    let id: Int
    let email: String
    let nickname: String
    let loginType: String
    let role: String
    let accessToken: String?
    let refreshToken: String?
}
