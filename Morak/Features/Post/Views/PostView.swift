//
//  PostView.swift
//  Morak
//
//  Created by Hong jeongmin on 8/12/25.
//

import SwiftUI

struct PostView: View {
    @StateObject private var viewModel = PostViewModel()
    @State private var selectedFilter: FilterOption = .latest

    var body: some View {
        VStack(spacing: 0) {
            PostHeaderView()

            FilterSectionView(
                selectedFilter: $selectedFilter,
                onFilterChange: { filter in
                    Task {
                        await viewModel.fetchPosts(sortBy: filter, refresh: true)
                    }
                }
            )

            // 포스트 리스트
            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(viewModel.posts) { post in
                        PostCardView(post: post)
                    }

                    if viewModel.isLoading {
                        ProgressView()
                            .padding()
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 12)
            }
            .background(Color.postBackground)
        }
        .background(Color.postBackground.ignoresSafeArea())
        .task {
            await viewModel.fetchPosts(sortBy: selectedFilter)
        }
    }
}

// MARK: - Filter Section View
struct FilterSectionView: View {
    @Binding var selectedFilter: FilterOption
    let onFilterChange: (FilterOption) -> Void

    var body: some View {
        HStack(spacing: 12) {
            // 필터 드롭다운 버튼
            Menu {
                ForEach(FilterOption.allCases, id: \.self) { option in
                    Button(action: {
                        selectedFilter = option
                        onFilterChange(option)
                    }) {
                        HStack {
                            Text(option.title)
                            if selectedFilter == option {
                                Image(systemName: "checkmark")
                            }
                        }
                    }
                }
            } label: {
                HStack(spacing: 8) {
                    Image(systemName: "line.3.horizontal.decrease.circle")
                        .font(.system(size: 16))
                        .foregroundColor(.textSecondary)

                    Text(selectedFilter.title)
                        .font(.pretendard.mediumTextRegular)
                        .foregroundColor(.textPrimary)

                    Image(systemName: "chevron.down")
                        .font(.system(size: 10))
                        .foregroundColor(.textSecondary)
                }
                .padding(.horizontal, 14)
                .padding(.vertical, 10)
                .background(Color.cardBackground)
                .cornerRadius(20)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.textSecondary.opacity(0.2), lineWidth: 1)
                )
            }

            Spacer()

            // 검색 버튼
            Button(action: {
                print("검색")
            }) {
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 16))
                    .foregroundColor(.textSecondary)
                    .frame(width: 40, height: 40)
                    .background(Color.cardBackground)
                    .cornerRadius(20)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.textSecondary.opacity(0.2), lineWidth: 1)
                    )
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
    }
}

// MARK: - Post Card View
struct PostCardView: View {
    let post: Post

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(post.nickname)
                .font(.pretendard.mediumTextSemiBold)
                .foregroundColor(.textPrimary)

            Text(post.content)
                .font(.pretendard.mediumTextRegular)
                .foregroundColor(.textSecondary)
                .lineLimit(6)
                .multilineTextAlignment(.leading)

            // 좋아요, 댓글 (오른쪽 정렬)
            HStack {
                Spacer()

                HStack(spacing: 12) {
                    // 좋아요 버튼
                    Button(action: {
                        print("좋아요 클릭: \(post.id)")
                    }) {
                        HStack(spacing: 4) {
                            Image(systemName: "heart")
                                .font(.system(size: 14))
                            Text("\(post.likeCount)")
                                .font(.pretendard.smallTextRegular)
                        }
                        .foregroundColor(.textSecondary)
                    }

                    // 댓글 버튼
                    Button(action: {
                        print("댓글 클릭: \(post.id)")
                    }) {
                        HStack(spacing: 4) {
                            Image(systemName: "bubble.right")
                                .font(.system(size: 14))
                            Text("\(post.commentCount)")
                                .font(.pretendard.smallTextRegular)
                        }
                        .foregroundColor(.textSecondary)
                    }
                }
            }
        }
        .padding(16)
        .background(Color.cardBackground)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
}
