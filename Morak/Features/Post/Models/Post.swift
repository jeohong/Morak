//
//  Post.swift
//  Morak
//
//  Created by Hong jeongmin on 11/3/25.
//

import Foundation

// MARK: - Post Model
struct Post: Codable, Identifiable {
    let id: Int
    let nickname: String
    let content: String
    let likeCount: Int
    let commentCount: Int

    enum CodingKeys: String, CodingKey {
        case id
        case nickname
        case content
        case likeCount = "like_count"
        case commentCount = "comment_count"
    }
}

// MARK: - Post List Request
struct PostListRequest: Codable {
    let page: Int
    let size: Int
    let sortBy: String // "latest", "oldest", "likes", "comments", "views"

    enum CodingKeys: String, CodingKey {
        case page
        case size
        case sortBy = "sort_by"
    }
}

// MARK: - Post List Response
struct PostListData: Codable {
    let posts: [Post]
    let totalCount: Int
    let currentPage: Int
    let totalPages: Int

    enum CodingKeys: String, CodingKey {
        case posts
        case totalCount = "total_count"
        case currentPage = "current_page"
        case totalPages = "total_pages"
    }
}

// MARK: - Dummy Data for Preview
extension Post {
    static let dummyPosts: [Post] = [
        Post(
            id: 1,
            nickname: "정스토리",
            content: "벚꽃이 흩날리던 그 봄날, 처음으로 느껴진 설렘을 글로 담아보려 했어요. 그때의 감정을 다시 느껴보고 싶어서 이렇리던 그 봄날, 처음으로 느껴진 설렘을 글로 담아보려 했어요. 그때의 감정을 다시 느껴보고 싶어서 이렇리던 그 봄날, 처음으로 느껴진 설렘을 글로 담아보려 했어요. 그때의 감정을 다시 느껴보고 싶어서 이렇리던 그 봄날, 처음으로 느껴진 설렘을 글로 담아보려 했어요. 그때의 감정을 다시 느껴보고 싶어서 이렇리던 그 봄날, 처음으로 느껴진 설렘을 글로 담아보려 했어요. 그때의 감정을 다시 느껴보고 싶어서 이렇리던 그 봄날, 처음으로 느껴진 설렘을 글로 담아보려 했어요. 그때의 감정을 다시 느껴보고 싶어서 이렇리던 그 봄날, 처음으로 느껴진 설렘을 글로 담아보려 했어요. 그때의 감정을 다시 느껴보고 싶어서 이렇리던 그 봄날, 처음으로 느껴진 설렘을 글로 담아보려 했어요. 그때의 감정을 다시 느껴보고 싶어서 이렇리던 그 봄날, 처음으로 느껴진 설렘을 글로 담아보려 했어요. 그때의 감정을 다시 느껴보고 싶어서 이렇리던 그 봄날, 처음으로 느껴진 설렘을 글로 담아보려 했어요. 그때의 감정을 다시 느껴보고 싶어서 이렇리던 그 봄날, 처음으로 느껴진 설렘을 글로 담아보려 했어요. 그때의 감정을 다시 느껴보고 싶어서 이렇리던 그 봄날, 처음으로 느껴진 설렘을 글로 담아보려 했어요. 그때의 감정을 다시 느껴보고 싶어서 이렇리던 그 봄날, 처음으로 느껴진 설렘을 글로 담아보려 했어요. 그때의 감정을 다시 느껴보고 싶어서 이렇리던 그 봄날, 처음으로 느껴진 설렘을 글로 담아보려 했어요. 그때의 감정을 다시 느껴보고 싶어서 이렇리던 그 봄날, 처음으로 느껴진 설렘을 글로 담아보려 했어요. 그때의 감정을 다시 느껴보고 싶어서 이렇게 글을 쓰게 되었어요. 긴 시간이 지났지만 여전히 그때의 기억은 선명하게 남아있네요.",
            likeCount: 18,
            commentCount: 6
        ),
        Post(
            id: 2,
            nickname: "최문학",
            content: "비가 내리는 소리를 들으며 창가에 앉아 있었다. 빗방울이 유리창을 타고 흘러내리는 모습을 보며 많은 생각을 했다. 때로는 비 오는 날이 좋다. 감정을 숨기기 좋은 날씨니까.",
            likeCount: 31,
            commentCount: 12
        ),
        Post(
            id: 3,
            nickname: "박시인",
            content: "10년 전 처음 갔던 그 작은 카페, 지금은 없어졌지만 그때의 기억은 여전히 생생하다. 따뜻한 커피 향과 함께했던 그 시간들이 그립다.",
            likeCount: 67,
            commentCount: 23
        ),
        Post(
            id: 4,
            nickname: "김작가",
            content: "밤하늘을 올려다보면 보이는 달. 그 달빛 아래서 나는 무엇을 생각하고 있었을까. 시간이 흘러도 달은 그 자리에 있고, 나는 여전히 그 달을 바라보고 있다.",
            likeCount: 42,
            commentCount: 15
        ),
        Post(
            id: 5,
            nickname: "이소설",
            content: "때로는 말로 표현할 수 없는 감정들이 있다. 그럴 때 나는 색으로 그 감정을 담아낸다. 빨강, 파랑, 노랑... 각각의 색이 내 마음을 대신 말해준다.",
            likeCount: 89,
            commentCount: 34
        ),
        Post(
            id: 6,
            nickname: "윤시인",
            content: "오늘 하루도 무사히 지나갔다. 특별한 일은 없었지만 평범한 하루가 때로는 가장 소중한 것 같다. 내일도 이런 평온한 하루였으면 좋겠다.",
            likeCount: 56,
            commentCount: 19
        )
    ]
}
