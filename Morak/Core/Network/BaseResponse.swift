//
//  BaseResponse.swift
//  Morak
//
//  Created by Hong jeongmin on 9/12/25.
//

import Foundation

struct BaseResponse<T: Codable>: Codable {
    let message: String
    let data: T
}

struct ErrorResponse: Codable {
    let message: String
}

struct EmptyData: Codable {}

// 로그아웃 응답용 (data가 null인 경우)
struct LogoutResponse: Codable {
    let message: String
    let data: String? // null 값을 받기 위해 Optional String
}
