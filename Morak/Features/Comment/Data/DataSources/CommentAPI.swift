//
//  CommentAPI.swift
//  Morak
//
//  Created by Hong jeongmin on 11/11/25.
//

import Foundation

enum CommentEndpoint: APIEndpoint {
    case getCommentList(CommentListRequest)
    case getReplies(ReplyListRequest)
    case createComment(CreateCommentRequest)
    case likeComment(commentId: Int)

    var baseURL: String {
        return baseUrl
    }

    var path: String {
        switch self {
        case .getCommentList:
            return "api/v1/comments/root"
        case .getReplies(let request):
            return "api/v1/comments/\(request.parentId)/replies"
        case .createComment:
            return "api/v1/comments"
        case .likeComment(let commentId):
            return "api/v1/comments/\(commentId)/like"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .getCommentList, .getReplies:
            return .GET
        case .createComment, .likeComment:
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
            print("🔑 [CommentEndpoint] Authorization 헤더 추가됨 - \(method.rawValue) \(path)")
        } else {
            print("ℹ️ [CommentEndpoint] Access Token 없음 - Authorization 헤더 제외 - \(method.rawValue) \(path)")
        }

        return headers
    }

    var requestBody: (any Codable)? {
        switch self {
        case .createComment(let request):
            return request
        default:
            return nil
        }
    }

    var queryParameters: [String: String]? {
        switch self {
        case .getCommentList(let request):
            return [
                "postId": "\(request.postId)",
                "page": "\(request.page)",
                "size": "\(request.size)",
                "sortBy": request.sortBy
            ]
        case .getReplies(let request):
            return [
                "page": "\(request.page)",
                "size": "\(request.size)"
            ]
        case .createComment, .likeComment:
            return nil
        }
    }
}
