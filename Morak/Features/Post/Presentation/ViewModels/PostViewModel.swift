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
    // MARK: - Published Properties
    @Published var posts: [Post] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var showTokenExpiredAlert: Bool = false
    @Published var selectedFilter: FilterOption = .latest

    // MARK: - Private Properties
    private var currentPage: Int = 1
    private var hasMorePages: Bool = true
    private let getPostListUseCase: GetPostListUseCaseProtocol
    private let likePostUseCase: LikePostUseCaseProtocol
    private let pageSize: Int = 10
    private var hasInitialLoaded: Bool = false
    private var previousIsLoggedIn: Bool = false

    private let authManager: AuthManager

    init(
        getPostListUseCase: GetPostListUseCaseProtocol,
        likePostUseCase: LikePostUseCaseProtocol,
        authManager: AuthManager
    ) {
        self.getPostListUseCase = getPostListUseCase
        self.likePostUseCase = likePostUseCase
        self.authManager = authManager
        self.previousIsLoggedIn = authManager.isLoggedIn

        observeAuthStateChanges()
    }

    func fetchPosts(sortBy: FilterOption, refresh: Bool = false) async {
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
            let response = try await getPostListUseCase.execute(page: currentPage, size: pageSize, sortBy: sortBy.apiValue)
            
            if refresh {
                posts = response.content
            } else {
                posts.append(contentsOf: response.content)
            }
            
            currentPage += 1
            hasMorePages = !response.last

        } catch let error as NetworkError {
            // 토큰 만료 (장기 미접속) 에러는 별도 처리
            if case .tokenRefreshFailed = error {
                showTokenExpiredAlert = true
            } else {
                errorMessage = error.localizedDescription
            }
        } catch {
            errorMessage = "알 수 없는 오류가 발생했습니다."
        }

        isLoading = false
    }

    func toggleLike(postId: Int) async {
        do {
            let serverResponse = try await likePostUseCase.execute(postId: postId)

            if let index = posts.firstIndex(where: { $0.id == postId }) {
                posts[index].updateLikeState(serverResponse: serverResponse)
            }

            if serverResponse == nil {
                errorMessage = "좋아요 처리 중 오류가 발생했습니다."
            }
        } catch let error as NetworkError {
            // 토큰 만료 에러는 별도 처리
            if case .tokenRefreshFailed = error {
                showTokenExpiredAlert = true
            } else {
                errorMessage = error.localizedDescription
            }
        } catch {
            errorMessage = "알 수 없는 오류가 발생했습니다."
        }
    }

    // MARK: - Public Methods

    /// 초기 로드 (최초 한 번만 실행)
    func loadInitialDataIfNeeded() {
        guard !hasInitialLoaded else { return }
        hasInitialLoaded = true

        Task {
            await fetchPosts(sortBy: selectedFilter)
        }
    }

    /// 필터 변경
    func changeFilter(_ filter: FilterOption) {
        selectedFilter = filter
        Task {
            await fetchPosts(sortBy: filter, refresh: true)
        }
    }

    /// 로그인 화면에서 돌아올 때 처리
    func handleLoginViewDismissed() {
        authManager.checkLoginStatus()
        let currentLoginState = authManager.isLoggedIn

        // 로그인 상태 변경 없이 로그인 화면만 다녀온 경우에만 새로고침
        if previousIsLoggedIn == currentLoginState {
            Task {
                await fetchPosts(sortBy: selectedFilter, refresh: true)
            }
        }
    }

    /// 글 작성 성공 후 목록 새로고침
    func handlePostCreated() {
        Task {
            await fetchPosts(sortBy: selectedFilter, refresh: true)
        }
    }

    // MARK: - Private Methods

    /// 로그인 상태 변경 관찰
    private func observeAuthStateChanges() {
        // authManager.isLoggedIn 변경 시 자동으로 새로고침
        // Combine을 사용하거나, View에서 onChange로 처리 가능
        // 여기서는 View에서 호출하는 방식으로 유지
    }

    /// 로그인 상태 변경 처리 (View에서 호출)
    func handleAuthStateChanged(isLoggedIn: Bool) {
        if previousIsLoggedIn != isLoggedIn {
            Task {
                await fetchPosts(sortBy: selectedFilter, refresh: true)
            }
        }
        previousIsLoggedIn = isLoggedIn
    }
}

// MARK: - Factory
extension PostViewModel {
    static func makeDefault() -> PostViewModel {
        let getPostListUseCase = GetPostListUseCase.makeDefault()
        let likePostUseCase = LikePostUseCase.makeDefault()
        let authManager = AuthManager.shared
        return PostViewModel(
            getPostListUseCase: getPostListUseCase,
            likePostUseCase: likePostUseCase,
            authManager: authManager
        )
    }
}
