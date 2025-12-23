//
//  FriendListTabView.swift
//  Morak
//
//  Created by Hong jeongmin on 11/27/25.
//

import SwiftUI

struct FriendListTabView: View {
    let friends: [Friend]
    let onDeleteFriend: (Friend) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Header
            HStack(spacing: 6) {
                Image(systemName: "person.2")
                    .font(.system(size: 14))
                    .foregroundColor(.textSecondary)

                Text("친구 \(friends.count)명")
                    .font(.pretendard.mediumTextMedium)
                    .foregroundColor(.textPrimary)
            }
            .padding(.horizontal, 16)
            .padding(.top, 16)
            .padding(.bottom, 12)

            // Friend List
            ScrollView {
                LazyVStack(spacing: 8) {
                    ForEach(friends) { friend in
                        FriendRowView(
                            friend: friend,
                            onDelete: { onDeleteFriend(friend) }
                        )
                    }
                }
                .padding(.horizontal, 16)
            }
        }
    }
}

// MARK: - Friend Row View
struct FriendRowView: View {
    let friend: Friend
    let onDelete: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            // Info
            VStack(alignment: .leading, spacing: 4) {
                Text(friend.nickname)
                    .font(.pretendard.mediumTextMedium)
                    .foregroundColor(.textPrimary)

                Text("친구")
                    .font(.pretendard.smallTextRegular)
                    .foregroundColor(.textSecondary)
            }

            Spacer()

            // Delete Button
            Button {
                onDelete()
            } label: {
                HStack(spacing: 4) {
                    Image(systemName: "person.badge.minus")
                        .font(.system(size: 12))
                    Text("친구삭제")
                        .font(.pretendard.smallTextMedium)
                }
                .foregroundColor(.red)
                .padding(.horizontal, 14)
                .padding(.vertical, 8)
                .background(Color.cardBackground)
                .cornerRadius(16)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.red.opacity(0.3), lineWidth: 1)
                )
            }
        }
        .padding(16)
        .background(Color.cardBackground)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.06), radius: 8, x: 0, y: 2)
    }
}

#Preview {
    FriendListTabView(
        friends: [
            Friend(id: 1, nickname: "김작가"),
            Friend(id: 2, nickname: "이소설")
        ],
        onDeleteFriend: { _ in }
    )
    .background(Color.postBackground)
}
