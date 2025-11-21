//
//  UpdateDTO.swift
//  Morak
//
//  Created by Hong jeongmin on 11/21/25.
//

import Foundation

struct UpdatePostRequest: Codable {
    let content: String

    enum CodingKeys: String, CodingKey {
        case content
    }
}
