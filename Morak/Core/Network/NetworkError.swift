//
//  NetworkError.swift
//  Morak
//
//  Created by Hong jeongmin on 9/12/25.
//

import Foundation

enum NetworkError: Error, LocalizedError {
    case invalidURL
    case invalidResponse
    case noData
    case decodingError
    case encodingError
    case serverError(Int, String?)
    case unauthorized
    case networkUnavailable
    case timeout
    case unknown
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "유효하지 않은 URL입니다."
        case .invalidResponse:
            return "잘못된 응답입니다."
        case .noData:
            return "데이터가 없습니다."
        case .decodingError:
            return "데이터 파싱에 실패했습니다."
        case .encodingError:
            return "데이터 인코딩에 실패했습니다."
        case .serverError(let statusCode, let message):
            return message ?? "서버 오류가 발생했습니다. (코드: \(statusCode))"
        case .unauthorized:
            return "인증이 필요합니다."
        case .networkUnavailable:
            return "네트워크 연결을 확인해주세요."
        case .timeout:
            return "요청 시간이 초과되었습니다."
        case .unknown:
            return "알 수 없는 오류가 발생했습니다."
        }
    }
}