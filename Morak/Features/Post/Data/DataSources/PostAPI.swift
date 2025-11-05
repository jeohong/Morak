//
//  PostAPI.swift
//  Morak
//
//  Created by Hong jeongmin on 11/4/25.
//

import Foundation

enum PostEndpoint: APIEndpoint {
    case getPostList(PostListRequest)
    case likePost(postId: Int)

    var baseURL: String {
        return baseUrl
    }

    var path: String {
        switch self {
        case .getPostList:
            return "api/v1/posts"
        case .likePost(let postId):
            return "api/v1/posts/\(postId)/like"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .getPostList:
            return .GET
        case .likePost:
            return .POST
        }
    }

    var headers: [String: String]? {
        var headers = [
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]

        // 토큰이 있을 때만 Authorization 헤더 추가
        if let accessToken = SecureTokenManager.shared.getAccessToken() {
            headers["Authorization"] = "Bearer \(accessToken)"
            print("🔑 [PostEndpoint] Authorization 헤더 추가됨")
        } else {
            print("ℹ️ [PostEndpoint] Access Token 없음 - Authorization 헤더 제외")
        }

        return headers
    }

    var requestBody: (any Codable)? {
        return nil
    }

    var queryParameters: [String: String]? {
        switch self {
        case .getPostList(let request):
            return [
                "page": "\(request.page)",
                "size": "\(request.size)",
                "sortBy": request.sortBy
            ]
        case .likePost:
            return nil
        }
    }
}
