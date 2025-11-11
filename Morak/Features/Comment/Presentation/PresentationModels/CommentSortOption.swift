//
//  CommentSortOption.swift
//  Morak
//
//  Created by Hong jeongmin on 11/11/25.
//

import Foundation

enum CommentSortOption: String, CaseIterable {
    case latest = "최신순"
    case oldest = "오래된순"
    case likes = "좋아요순"

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
        }
    }
}
