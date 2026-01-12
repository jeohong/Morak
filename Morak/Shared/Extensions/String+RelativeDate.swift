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

        // 서버에서 한국 시간으로 보내는 경우 (타임존 정보 없음)
        formatter.timeZone = TimeZone(identifier: "Asia/Seoul")

        // 마이크로초 포함 형식
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"
        if let date = formatter.date(from: self) {
            return date
        }

        // 밀리초 포함 형식
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
        if let date = formatter.date(from: self) {
            return date
        }

        // 초 단위 형식
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        if let date = formatter.date(from: self) {
            return date
        }

        // 공백 구분 형식 (yyyy-MM-dd HH:mm:ss)
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        if let date = formatter.date(from: self) {
            return date
        }

        // 표준 ISO8601 형식 (타임존 정보 포함된 경우)
        let isoFormatter = ISO8601DateFormatter()
        return isoFormatter.date(from: self)
    }
}
