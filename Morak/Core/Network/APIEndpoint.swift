//
//  APIEndpoint.swift
//  Morak
//
//  Created by Hong jeongmin on 9/12/25.
//

import Foundation

protocol APIEndpoint {
    var baseURL: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: [String: String]? { get }
    var requestBody: (any Codable)? { get }
    var queryParameters: [String: String]? { get }
}

enum HTTPMethod: String {
    case GET = "GET"
    case POST = "POST"
    case PUT = "PUT"
    case DELETE = "DELETE"
    case PATCH = "PATCH"
}

enum AuthEndpoint: APIEndpoint {
    case login(LoginRequest)
    case logout
    case signup(SignupRequest)
    case refresh(RefreshTokenRequest)

    var baseURL: String {
        return baseUrl
    }
    
    var path: String {
        switch self {
        case .login:
            return "api/v1/auth/login"
        case .logout:
            return "api/v1/auth/logout"
        case .signup:
            return "api/v1/auth/signup"
        case .refresh:
            return "api/v1/auth/refresh"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .login, .logout, .signup, .refresh:
            return .POST
        }
    }
    
    var headers: [String: String]? {
        var headers = [
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]

        // 로그아웃 시 Authorization 헤더 추가
        switch self {
        case .logout:
            if let accessToken = SecureTokenManager.shared.getAccessToken() {
                headers["Authorization"] = "Bearer \(accessToken)"
            }
        default:
            break
        }

        return headers
    }
    
    var requestBody: (any Codable)? {
        switch self {
        case .login(let loginRequest):
            return loginRequest
        case .logout:
            return nil
        case .signup(let signupRequest):
            return signupRequest
        case .refresh(let refreshRequest):
            return refreshRequest
        }
    }

    var queryParameters: [String: String]? {
        return nil
    }
}

enum EmailEndpoint: APIEndpoint {
    case checkEmail(EmailCheckRequest)
    case sendEmail(EmailSendRequest)
    case verifyEmail(EmailVerifyRequest)

    var baseURL: String {
        return baseUrl
    }

    var path: String {
        switch self {
        case .checkEmail:
            return "api/v1/email/check-email"
        case .sendEmail:
            return "api/v1/email/send-email"
        case .verifyEmail:
            return "api/v1/email/verify-email"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .checkEmail:
            return .GET
        case .sendEmail, .verifyEmail:
            return .POST
        }
    }

    var headers: [String: String]? {
        return [
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]
    }

    var requestBody: (any Codable)? {
        switch self {
        case .checkEmail, .sendEmail:
            return nil
        case .verifyEmail(let emailVerifyRequest):
            return emailVerifyRequest
        }
    }

    var queryParameters: [String: String]? {
        switch self {
        case .checkEmail(let emailCheckRequest):
            return ["email": emailCheckRequest.email]
        case .sendEmail(let emailSendRequest):
            return ["email": emailSendRequest.email]
        case .verifyEmail:
            return nil
        }
    }
}

enum UserEndpoint: APIEndpoint {
    case search(nickname: String)
    case getMyInfo
    case withdrawal

    var baseURL: String {
        return baseUrl
    }

    var path: String {
        switch self {
        case .search:
            return "api/v1/users/search"
        case .getMyInfo:
            return "api/v1/users/me"
        case .withdrawal:
            return "api/v1/users/withdrawal"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .search, .getMyInfo:
            return .GET
        case .withdrawal:
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
        }

        return headers
    }

    var requestBody: (any Codable)? {
        return nil
    }

    var queryParameters: [String: String]? {
        switch self {
        case .search(let nickname):
            return ["nickname": nickname]
        case .getMyInfo, .withdrawal:
            return nil
        }
    }
}

enum FriendEndpoint: APIEndpoint {
    case getFriends
    case getReceivedRequests
    case acceptRequest(requestId: Int)
    case rejectRequest(requestId: Int)
    case sendRequest(receiverId: Int)
    case deleteFriend(friendId: Int)

    var baseURL: String {
        return baseUrl
    }

    var path: String {
        switch self {
        case .getFriends:
            return "api/v1/friends"
        case .getReceivedRequests:
            return "api/v1/friends/requests/received"
        case .acceptRequest(let requestId):
            return "api/v1/friends/request/\(requestId)/accept"
        case .rejectRequest(let requestId):
            return "api/v1/friends/request/\(requestId)/reject"
        case .sendRequest(let receiverId):
            return "api/v1/friends/request/\(receiverId)"
        case .deleteFriend(let friendId):
            return "api/v1/friends/\(friendId)/delete"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .getFriends, .getReceivedRequests:
            return .GET
        case .acceptRequest, .rejectRequest, .sendRequest, .deleteFriend:
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
        }

        return headers
    }

    var requestBody: (any Codable)? {
        return nil
    }

    var queryParameters: [String: String]? {
        return nil
    }
}
