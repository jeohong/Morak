//
//  LikeDTO.swift
//  Morak
//
//  Created by Hong jeongmin on 11/5/25.
//

import Foundation

// MARK: - Like Response DTO
struct LikeResponseDTO: Codable {
    let success: Bool
    let message: String
    let data: Bool?  // null일 수 있음
}
