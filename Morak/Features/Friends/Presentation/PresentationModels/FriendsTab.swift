//
//  FriendsTab.swift
//  Morak
//
//  Created by Hong jeongmin on 11/27/25.
//

import Foundation

enum FriendsTab: Int, CaseIterable {
    case search = 0
    case friends = 1
    case requests = 2

    var title: String {
        switch self {
        case .search:
            return "검색"
        case .friends:
            return "친구"
        case .requests:
            return "요청"
        }
    }
}
