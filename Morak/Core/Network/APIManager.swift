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
    
    private init() {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 30.0
        config.timeoutIntervalForResource = 60.0
        self.session = URLSession(configuration: config)
    }
    
    func request<T: Codable>(_ endpoint: any APIEndpoint, responseType: T.Type) async throws -> T {
        guard let url = URL(string: endpoint.baseURL + endpoint.path) else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        
        // 헤더 설정
        endpoint.headers?.forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        // POST 요청인 경우 body 설정
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
            case 401:
                throw NetworkError.unauthorized
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
                print("Decoding error: \(error)")
                throw NetworkError.decodingError
            }
            
        } catch let error as NetworkError {
            throw error
        } catch {
            if let urlError = error as? URLError {
                switch urlError.code {
                case .notConnectedToInternet, .networkConnectionLost:
                    throw NetworkError.networkUnavailable
                case .timedOut:
                    throw NetworkError.timeout
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