//
//  FilterOption.swift
//  Morak
//
//  Created by Hong jeongmin on 8/29/25.
//

import Foundation

enum FilterOption: String, CaseIterable {
    case latest = "최신순"
    case oldest = "오래된순"
    case likes = "좋아요순"
    case comments = "댓글순"
    case views = "조회순"

    var title: String {
        return self.rawValue
    }

    var apiValue: String {
        switch self {
        case .latest:
            return "CREATED_AT_DESC"
        case .oldest:
            return "CREATED_AT_ASC"
        case .likes:
            return "LIKE_COUNT"
        case .comments:
            return "COMMENT_COUNT"
        case .views:
            return "VIEW_COUNT"
        }
    }
}
