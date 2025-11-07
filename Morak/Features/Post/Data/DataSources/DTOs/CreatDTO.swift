//
//  CreatDTO.swift
//  Morak
//
//  Created by 홍정민 on 11/7/25.
//

import Foundation

struct CreatePostRequest: Codable {
    let content: String

    enum CodingKeys: String, CodingKey {
        case content
    }
}
