//
//  FriendSearchTabView.swift
//  Morak
//
//  Created by Hong jeongmin on 11/27/25.
//

import SwiftUI

struct FriendSearchTabView: View {
    @Binding var searchText: String
    let searchResults: [Friend]
    let onSearch: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            // Search Bar
            HStack(spacing: 12) {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.textSecondary)
                    .font(.system(size: 16))

                TextField("닉네임으로 검색...", text: $searchText)
                    .font(.pretendard.mediumTextRegular)
                    .foregroundColor(.textPrimary)
                    .onSubmit {
                        onSearch()
                    }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .background(Color.cardBackground)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.textSecondary.opacity(0.1), lineWidth: 1)
            )
            .padding(.horizontal, 16)
            .padding(.top, 12)

            // Search Results
            if searchResults.isEmpty {
                Spacer()
            } else {
                ScrollView {
                    LazyVStack(spacing: 0) {
                        ForEach(searchResults) { friend in
                            SearchResultRowView(friend: friend)
                        }
                    }
                    .padding(.top, 16)
                }
            }

            Spacer()
        }
    }
}

// MARK: - Search Result Row
struct SearchResultRowView: View {
    let friend: Friend

    var body: some View {
        HStack(spacing: 12) {
            // Name
            Text(friend.nickname)
                .font(.pretendard.mediumTextMedium)
                .foregroundColor(.textPrimary)

            Spacer()

            // Add Friend Button
            Button {
                // TODO: 친구 추가 요청
            } label: {
                Text("친구 추가")
                    .font(.pretendard.smallTextMedium)
                    .foregroundColor(.white)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 8)
                    .background(Color.orangeButton)
                    .cornerRadius(16)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color.cardBackground)
        .cornerRadius(12)
        .padding(.horizontal, 16)
        .padding(.vertical, 4)
    }
}

#Preview {
    FriendSearchTabView(
        searchText: .constant(""),
        searchResults: [],
        onSearch: {}
    )
    .background(Color.postBackground)
}
