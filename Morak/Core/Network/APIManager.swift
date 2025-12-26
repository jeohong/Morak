//
//  APIManager.swift
//  Morak
//
//  Created by Hong jeongmin on 9/12/25.
//

import Foundation

protocol APIManagerProtocol {
    func request<T: Codable>(_ endpoint: any APIEndpoint, responseType: T.Type) async throws -> T
}

final class APIManager: APIManagerProtocol {
    static let shared = APIManager()

    private let session: URLSession
    private var isRefreshing = false

    private init() {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 30.0
        config.timeoutIntervalForResource = 60.0
        self.session = URLSession(configuration: config)
    }

    func request<T: Codable>(_ endpoint: any APIEndpoint, responseType: T.Type) async throws -> T {
        return try await requestWithRetry(endpoint, responseType: responseType, isRetry: false)
    }

    private func requestWithRetry<T: Codable>(_ endpoint: any APIEndpoint, responseType: T.Type, isRetry: Bool) async throws -> T {
        var urlString = endpoint.baseURL + endpoint.path

        if let queryParameters = endpoint.queryParameters, !queryParameters.isEmpty {
            var urlComponents = URLComponents(string: urlString)
            urlComponents?.queryItems = queryParameters.map { URLQueryItem(name: $0.key, value: $0.value) }
            urlString = urlComponents?.url?.absoluteString ?? urlString
        }

        guard let url = URL(string: urlString) else {
            throw NetworkError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue

        // 헤더 설정
        endpoint.headers?.forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }

        if endpoint.method != .GET, let requestBody = endpoint.requestBody {
            do {
                let encoder = JSONEncoder()
                request.httpBody = try encoder.encode(requestBody)
            } catch {
                throw NetworkError.encodingError
            }
        }

        do {
            let (data, response) = try await session.data(for: request)

            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.invalidResponse
            }

            // 상태 코드 체크
            switch httpResponse.statusCode {
            case 200...299:
                break
            case 400...499, 500...599:
                // 에러 응답에서 메시지 파싱 시도
                let errorMessage = parseErrorMessage(from: data)
                throw NetworkError.serverError(httpResponse.statusCode, errorMessage)
            default:
                throw NetworkError.unknown
            }

            guard !data.isEmpty else {
                throw NetworkError.noData
            }

            do {
                let decodedResponse = try JSONDecoder().decode(responseType, from: data)
                return decodedResponse
            } catch {
                throw NetworkError.decodingError
            }
            
        } catch let error as NetworkError {
            // 인증 관련 API는 자동 갱신 제외 (로그인, 회원가입, refresh)
            let shouldSkipRefresh = endpoint.path.contains("/auth/login") ||
                                   endpoint.path.contains("/auth/signup") ||
                                   endpoint.path.contains("/auth/refresh")

            // 401 에러이고 아직 재시도하지 않았으면 토큰 갱신 시도
            if case .serverError(let statusCode, _) = error,
               statusCode == 401,
               !isRetry,
               !shouldSkipRefresh {
                do {
                    // 토큰 갱신 시도
                    _ = try await AuthManager.shared.refreshToken()
                    // 갱신 성공 시 원래 요청 재시도
                    return try await requestWithRetry(endpoint, responseType: responseType, isRetry: true)
                } catch {
                    // 갱신 실패 시 장기 미접속 에러
                    throw NetworkError.tokenRefreshFailed
                }
            }
            throw error
        } catch {
            if let urlError = error as? URLError {
                switch urlError.code {
                case .notConnectedToInternet, .networkConnectionLost:
                    throw NetworkError.networkUnavailable
                case .timedOut:
                    throw NetworkError.timeout
                case .cancelled:
                    throw NetworkError.cancelled
                default:
                    throw NetworkError.unknown
                }
            }
            throw NetworkError.unknown
        }
    }
    
    private func parseErrorMessage(from data: Data) -> String? {
        do {
            let errorResponse = try JSONDecoder().decode(ErrorResponse.self, from: data)
            return errorResponse.message
        } catch {
            // JSON 파싱 실패 시 nil 반환
            return nil
        }
    }
}
