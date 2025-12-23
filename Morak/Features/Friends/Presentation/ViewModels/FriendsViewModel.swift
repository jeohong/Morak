//
//  FriendsViewModel.swift
//  Morak
//
//  Created by Hong jeongmin on 11/27/25.
//

import Foundation

@MainActor
final class FriendsViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var selectedTab: FriendsTab = .search
    @Published var searchText: String = ""
    @Published var friends: [Friend] = []
    @Published var friendRequests: [FriendRequest] = []
    @Published var searchResults: [Friend] = []
    @Published var isLoading: Bool = false
    @Published var requestBadgeCount: Int = 0
    @Published var errorMessage: String?

    // MARK: - Private Properties
    private let searchUsersUseCase: SearchUsersUseCaseProtocol

    // MARK: - Initialization
    init(searchUsersUseCase: SearchUsersUseCaseProtocol = SearchUsersUseCase.makeDefault()) {
        self.searchUsersUseCase = searchUsersUseCase
        loadMockData()
    }

    // MARK: - Mock Data
    private func loadMockData() {
        friends = [
            Friend(id: 1, nickname: "김작가"),
            Friend(id: 2, nickname: "이소설")
        ]

        friendRequests = [
            FriendRequest(
                id: 1,
                nickname: "박시인",
                requestedAt: Date().addingTimeInterval(-2 * 3600)
            )
        ]

        requestBadgeCount = friendRequests.count
    }

    // MARK: - Actions
    func searchFriends() {
        guard !searchText.isEmpty else {
            searchResults = []
            return
        }

        Task {
            await performSearch()
        }
    }

    private func performSearch() async {
        isLoading = true
        errorMessage = nil

        do {
            let results = try await searchUsersUseCase.execute(nickname: searchText)
            searchResults = results
        } catch {
            errorMessage = "검색 중 오류가 발생했습니다."
            searchResults = []
        }

        isLoading = false
    }

    func acceptFriendRequest(_ request: FriendRequest) {
        // TODO: API 연동 시 구현
        friendRequests.removeAll { $0.id == request.id }
        friends.append(Friend(id: request.id, nickname: request.nickname))
        requestBadgeCount = friendRequests.count
    }

    func rejectFriendRequest(_ request: FriendRequest) {
        // TODO: API 연동 시 구현
        friendRequests.removeAll { $0.id == request.id }
        requestBadgeCount = friendRequests.count
    }

    func navigateToProfile(_ friend: Friend) {
        // TODO: 프로필 화면으로 이동
        print("Navigate to profile: \(friend.nickname)")
    }
}
