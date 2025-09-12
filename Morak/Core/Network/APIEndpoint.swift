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
    var parameters: [String: Any]? { get }
}

enum HTTPMethod: String {
    case GET = "GET"
    case POST = "POST"
    case PUT = "PUT"
    case DELETE = "DELETE"
    case PATCH = "PATCH"
}

enum AuthEndpoint: APIEndpoint {
    case login(email: String, password: String)
    case logout
    
    var baseURL: String {
        return baseUrl
    }
    
    var path: String {
        switch self {
        case .login:
            return "api/v1/auth/login"
        case .logout:
            return "api/v1/auth/logout"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .login:
            return .POST
        case .logout:
            return .POST
        }
    }
    
    var headers: [String: String]? {
        var headers = [
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]
        
        // 로그아웃 시 Authorization 헤더 추가
        if case .logout = self {
            if let accessToken = SecureTokenManager.shared.getAccessToken() {
                headers["Authorization"] = "Bearer \(accessToken)"
            }
        }
        
        return headers
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .login(let email, let password):
            return [
                "email": email,
                "password": password
            ]
        case .logout:
            return nil
        }
    }
}
