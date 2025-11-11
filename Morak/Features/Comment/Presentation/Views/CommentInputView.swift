//
//  CommentInputView.swift
//  Morak
//
//  Created by Hong jeongmin on 11/11/25.
//

import SwiftUI

struct CommentInputView: View {
    @Binding var text: String
    let onSubmit: () -> Void
    let replyingTo: Comment?
    let onCancelReply: (() -> Void)?
    let onLoginRequired: (() -> Void)?
    @ObservedObject var authManager = AuthManager.shared
    var focusedField: FocusState<Bool>.Binding

    var body: some View {
        VStack(spacing: 0) {
            // 답글 모드 표시
            if let replyingTo = replyingTo {
                HStack {
                    Text("\(replyingTo.nickname)에게 답글 작성 중")
                        .font(.pretendard.smallTextRegular)
                        .foregroundColor(.textSecondary)

                    Spacer()

                    Button(action: {
                        onCancelReply?()
                    }) {
                        Image(systemName: "xmark")
                            .font(.system(size: 12))
                            .foregroundColor(.textSecondary)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(Color.blue.opacity(0.1))
            }

            HStack(spacing: 12) {
                TextField(replyingTo == nil ? "댓글을 입력하세요..." : "답글을 입력하세요...", text: $text)
                    .font(.pretendard.mediumTextRegular)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(20)
                    .disabled(authManager.requiresLogin)
                    .focused(focusedField)
                    .onTapGesture {
                        if authManager.requiresLogin {
                            onLoginRequired?()
                        }
                    }

                Button(action: onSubmit) {
                    Text("등록")
                        .font(.pretendard.mediumTextSemiBold)
                        .foregroundColor(.white)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 12)
                        .background(text.isEmpty ? Color.gray : Color.blue)
                        .cornerRadius(20)
                }
                .disabled(text.isEmpty || authManager.requiresLogin)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
        }
        .background(Color.white)
        .overlay(
            Rectangle()
                .frame(height: 1)
                .foregroundColor(.gray.opacity(0.2)),
            alignment: .top
        )
    }
}
