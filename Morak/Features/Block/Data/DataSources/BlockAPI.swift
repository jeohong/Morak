//
//  BlockAPI.swift
//  Morak
//
//  Created by 홍정민 on 1/12/26.
//

import Foundation

enum BlockEndpoint: APIEndpoint {
    case blockUser(userId: Int)

    var baseURL: String {
        return baseUrl
    }

    var path: String {
        switch self {
        case .blockUser(let userId):
            return "api/v1/blocks/\(userId)"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .blockUser:
            return .POST
        }
    }

    var headers: [String: String]? {
        var headers = [
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]

        if let accessToken = SecureTokenManager.shared.getAccessToken() {
            headers["Authorization"] = "Bearer \(accessToken)"
            print("🔑 [BlockEndpoint] Authorization 헤더 추가됨 - \(method.rawValue) \(path)")
        } else {
            print("ℹ️ [BlockEndpoint] Access Token 없음 - Authorization 헤더 제외 - \(method.rawValue) \(path)")
        }

        return headers
    }

    var requestBody: (any Codable)? {
        switch self {
        case .blockUser:
            return nil
        }
    }

    var queryParameters: [String: String]? {
        switch self {
        case .blockUser:
            return nil
        }
    }
}
