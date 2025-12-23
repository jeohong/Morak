//
//  String+RelativeDate.swift
//  Morak
//
//  Created by Hong jeongmin on 11/11/25.
//

import Foundation

extension String {
    /// ISO8601 날짜 문자열을 상대적 시간 포맷으로 변환
    /// 예: "방금 전", "5분 전", "3시간 전", "2일 전", "24.11.05"
    var formattedAsRelativeTime: String {
        guard let date = parseISO8601Date() else {
            return self
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

    /// ISO8601 문자열을 Date로 파싱
    func toDate() -> Date? {
        return parseISO8601Date()
    }

    private func parseISO8601Date() -> Date? {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(identifier: "UTC")

        // 마이크로초 포함 형식
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"
        if let date = formatter.date(from: self) {
            return date
        }

        // 표준 ISO8601 형식
        let isoFormatter = ISO8601DateFormatter()
        return isoFormatter.date(from: self)
    }
}
