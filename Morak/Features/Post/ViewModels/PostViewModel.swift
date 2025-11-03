//
//  PostViewModel.swift
//  Morak
//
//  Created by Hong jeongmin on 11/3/25.
//

import Foundation
import SwiftUI

@MainActor
final class PostViewModel: ObservableObject {
    @Published var posts: [Post] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var currentPage: Int = 1
    @Published var hasMorePages: Bool = true

    private let repository: PostRepositoryProtocol
    private let pageSize: Int = 20
    private let useDummyData: Bool

    init(repository: PostRepositoryProtocol = PostRepository(), useDummyData: Bool = true) {
        self.repository = repository
        self.useDummyData = useDummyData

        // 더미 데이터 모드일 경우 바로 로드
        if useDummyData {
            self.posts = Post.dummyPosts
        }
    }

    func fetchPosts(sortBy: FilterOption, refresh: Bool = false) async {
        // 더미 데이터 모드일 경우 API 호출하지 않음
        if useDummyData {
            return
        }

        guard !isLoading else { return }

        if refresh {
            currentPage = 1
            hasMorePages = true
            posts = []
        }

        guard hasMorePages else { return }

        isLoading = true
        errorMessage = nil

        do {
            let request = PostListRequest(
                page: currentPage,
                size: pageSize,
                sortBy: sortBy.apiValue
            )

            let response = try await repository.getPostList(request)

            if refresh {
                posts = response.data.posts
            } else {
                posts.append(contentsOf: response.data.posts)
            }

            currentPage = response.data.currentPage + 1
            hasMorePages = response.data.currentPage < response.data.totalPages

        } catch let error as NetworkError {
            errorMessage = error.localizedDescription
        } catch {
            errorMessage = "알 수 없는 오류가 발생했습니다."
        }

        isLoading = false
    }
}

// FilterOption에 API 값 매핑 추가
extension FilterOption {
    var apiValue: String {
        switch self {
        case .latest:
            return "latest"
        case .oldest:
            return "oldest"
        case .likes:
            return "likes"
        case .comments:
            return "comments"
        case .views:
            return "views"
        }
    }
}
