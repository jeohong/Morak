//
//  AppTab.swift
//  Morak
//
//  Created by Hong jeongmin on 8/12/25.
//

import Foundation

enum AppTab: Hashable {
    case post
    case chat
    case setting
    case friends

    var title: String {
        switch self {
        case .post: "포스트"
        case .chat: "채팅"
        case .setting: "설정"
        case .friends: "친구"
        }
    }

    var systemImage: String {
        switch self {
        case .post: "tab_post"
        case .chat: "tab_chatting"
        case .setting: "tab_setting"
        case .friends: "tab_friends"
        }
    }
}
