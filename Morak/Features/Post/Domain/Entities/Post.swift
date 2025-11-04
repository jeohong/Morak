//
//  Post.swift
//  Morak
//
//  Created by Hong jeongmin on 11/3/25.
//

import Foundation

// MARK: - Post Entity (순수한 도메인 모델)
struct Post: Identifiable {
    let id: Int
    let nickname: String
    let content: String
    let likeCount: Int
    let commentCount: Int
    let viewCount: Int
    let createdAt: String
    let modifiedAt: String
    let likedByLoginUser: Bool

    var isLikedByMe: Bool {
        return likedByLoginUser
    }

    var isModified: Bool {
        return createdAt != modifiedAt
    }

    var formattedCreatedAt: String {
        guard let date = parseDate(createdAt) else {
            return createdAt
        }

        let now = Date()
        let timeDifference = now.timeIntervalSince(date)
        let hoursDifference = timeDifference / 3600
        let daysDifference = timeDifference / 86400

        // 24시간 이내
        if hoursDifference < 24 {
            let hours = Int(hoursDifference)
            if hours < 1 {
                let minutes = Int(timeDifference / 60)
                return minutes < 1 ? "방금 전" : "\(minutes)분 전"
            }
            return "\(hours)시간 전"
        }

        // 일주일 이내 (7일)
        if daysDifference < 7 {
            let days = Int(daysDifference)
            return "\(days)일 전"
        }

        // 일주일 이후 - YY.MM.DD 형식
        let formatter = DateFormatter()
        formatter.dateFormat = "yy.MM.dd"
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.timeZone = TimeZone.current
        return formatter.string(from: date)
    }

    private func parseDate(_ dateString: String) -> Date? {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(identifier: "UTC")

        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"
        if let date = formatter.date(from: dateString) {
            return date
        }

        let isoFormatter = ISO8601DateFormatter()
        return isoFormatter.date(from: dateString)
    }
}

// MARK: - Post List Response
struct PostListResponse {
    let content: [Post]
    let totalPages: Int
    let totalElements: Int
    let size: Int
    let number: Int
    let first: Bool
    let last: Bool

    var hasNextPage: Bool {
        return !last
    }

    var isEmpty: Bool {
        return content.isEmpty
    }
}
