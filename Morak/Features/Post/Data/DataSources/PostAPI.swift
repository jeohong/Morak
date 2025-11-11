//
//  PostAPI.swift
//  Morak
//
//  Created by Hong jeongmin on 11/4/25.
//

import Foundation

enum PostEndpoint: APIEndpoint {
    case getPostList(PostListRequest)
    case getPostDetail(postId: Int)
    case likePost(postId: Int)
    case createPost(CreatePostRequest)

    var baseURL: String {
        return baseUrl
    }

    var path: String {
        switch self {
        case .getPostList:
            return "api/v1/posts"
        case .getPostDetail(let postId):
            return "api/v1/posts/\(postId)"
        case .likePost(let postId):
            return "api/v1/posts/\(postId)/like"
        case .createPost:
            return "api/v1/posts"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .getPostList, .getPostDetail:
            return .GET
        case .likePost:
            return .POST
        case .createPost:
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
            print("🔑 [PostEndpoint] Authorization 헤더 추가됨 - \(method.rawValue) \(path)")
        } else {
            print("ℹ️ [PostEndpoint] Access Token 없음 - Authorization 헤더 제외 - \(method.rawValue) \(path)")
        }

        return headers
    }

    var requestBody: (any Codable)? {
        switch self {
        case .createPost(let request):
            return request
        default:
            return nil
        }
    }

    var queryParameters: [String: String]? {
        switch self {
        case .getPostList(let request):
            return [
                "page": "\(request.page)",
                "size": "\(request.size)",
                "sortBy": request.sortBy
            ]
        case .getPostDetail, .likePost, .createPost:
            return nil
        }
    }
}
