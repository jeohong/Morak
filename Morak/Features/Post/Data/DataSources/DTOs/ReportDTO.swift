//
//  ReportDTO.swift
//  Morak
//
//  Created by Hong jeongmin on 12/26/25.
//

import Foundation

struct ReportPostRequest: Codable {
    let reason: String

    enum CodingKeys: String, CodingKey {
        case reason
    }
}
