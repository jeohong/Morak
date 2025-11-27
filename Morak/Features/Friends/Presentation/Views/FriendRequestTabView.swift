//
//  FriendRequestTabView.swift
//  Morak
//
//  Created by Hong jeongmin on 11/27/25.
//

import SwiftUI

struct FriendRequestTabView: View {
    let requests: [FriendRequest]
    let onAccept: (FriendRequest) -> Void
    let onReject: (FriendRequest) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Header
            HStack(spacing: 6) {
                Image(systemName: "person.badge.plus")
                    .font(.system(size: 14))
                    .foregroundColor(.textSecondary)

                Text("친구 요청 \(requests.count)개")
                    .font(.pretendard.mediumTextMedium)
                    .foregroundColor(.textPrimary)
            }
            .padding(.horizontal, 16)
            .padding(.top, 16)
            .padding(.bottom, 12)

            // Request List
            if requests.isEmpty {
                VStack {
                    Spacer()
                    Text("받은 친구 요청이 없습니다")
                        .font(.pretendard.mediumTextRegular)
                        .foregroundColor(.textSecondary)
                    Spacer()
                }
                .frame(maxWidth: .infinity)
            } else {
                ScrollView {
                    LazyVStack(spacing: 8) {
                        ForEach(requests) { request in
                            FriendRequestRowView(
                                request: request,
                                onAccept: { onAccept(request) },
                                onReject: { onReject(request) }
                            )
                        }
                    }
                    .padding(.horizontal, 16)
                }
            }
        }
    }
}

// MARK: - Friend Request Row View
struct FriendRequestRowView: View {
    let request: FriendRequest
    let onAccept: () -> Void
    let onReject: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            // Info
            VStack(alignment: .leading, spacing: 4) {
                Text(request.nickname)
                    .font(.pretendard.mediumTextMedium)
                    .foregroundColor(.textPrimary)

                Text(request.requestedAt.relativeTimeString)
                    .font(.pretendard.smallTextRegular)
                    .foregroundColor(.textSecondary)
            }

            Spacer()

            // Action Buttons
            HStack(spacing: 8) {
                // Accept Button
                Button {
                    onAccept()
                } label: {
                    Image(systemName: "checkmark")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.white)
                        .frame(width: 36, height: 36)
                        .background(Color.orangeButton)
                        .clipShape(Circle())
                }

                // Reject Button
                Button {
                    onReject()
                } label: {
                    Image(systemName: "xmark")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.textSecondary)
                        .frame(width: 36, height: 36)
                        .background(Color.cardBackground)
                        .clipShape(Circle())
                        .overlay(
                            Circle()
                                .stroke(Color.textSecondary.opacity(0.2), lineWidth: 1)
                        )
                }
            }
        }
        .padding(16)
        .background(Color.cardBackground)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.06), radius: 8, x: 0, y: 2)
    }
}

// MARK: - Date Extension
extension Date {
    var relativeTimeString: String {
        let now = Date()
        let timeDifference = now.timeIntervalSince(self)
        let hoursDifference = timeDifference / 3600
        let daysDifference = timeDifference / 86400

        // 24시간 이내
        if hoursDifference < 24 {
            let hours = Int(hoursDifference)
            if hours < 1 {
                let minutes = Int(timeDifference / 60)
                return minutes < 1 ? "방금 전" : "\(minutes)분 전"
            }
            return "\(hours)시간 전"
        }

        // 일주일 이내 (7일)
        if daysDifference < 7 {
            let days = Int(daysDifference)
            return "\(days)일 전"
        }

        // 일주일 이후 - YY.MM.DD 형식
        let formatter = DateFormatter()
        formatter.dateFormat = "yy.MM.dd"
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.timeZone = TimeZone.current
        return formatter.string(from: self)
    }
}

#Preview {
    FriendRequestTabView(
        requests: [
            FriendRequest(
                id: 1,
                nickname: "박시인",
                requestedAt: Date().addingTimeInterval(-2 * 3600)
            )
        ],
        onAccept: { _ in },
        onReject: { _ in }
    )
    .background(Color.postBackground)
}
