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
    let editingComment: Comment?
    let onCancelReply: (() -> Void)?
    let onCancelEdit: (() -> Void)?
    let onLoginRequired: (() -> Void)?
    @ObservedObject var authManager = AuthManager.shared
    var focusedField: FocusState<Bool>.Binding

    private var isEditMode: Bool {
        editingComment != nil
    }

    private var placeholderText: String {
        if isEditMode {
            return "수정할 내용을 입력하세요..."
        } else if replyingTo != nil {
            return "답글을 입력하세요..."
        } else {
            return "댓글을 입력하세요..."
        }
    }

    var body: some View {
        VStack(spacing: 0) {
            // 수정 모드 표시
            if let editingComment = editingComment {
                HStack {
                    Text("댓글 수정 중")
                        .font(.pretendard.smallTextRegular)
                        .foregroundColor(.textSecondary)

                    Spacer()

                    Button(action: {
                        onCancelEdit?()
                    }) {
                        Image(systemName: "xmark")
                            .font(.system(size: 12))
                            .foregroundColor(.textSecondary)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(Color.orange.opacity(0.1))
            }
            // 답글 모드 표시
            else if let replyingTo = replyingTo {
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
                TextField(placeholderText, text: $text)
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
                    Text(isEditMode ? "수정" : "등록")
                        .font(.pretendard.mediumTextSemiBold)
                        .foregroundColor(.white)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 12)
                        .background(text.isEmpty ? Color.gray : (isEditMode ? Color.orange : Color.blue))
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
