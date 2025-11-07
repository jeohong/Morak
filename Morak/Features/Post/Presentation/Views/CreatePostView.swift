//
//  CreatePostView.swift
//  Morak
//
//  Created by Hong jeongmin on 11/7/25.
//

import SwiftUI

struct CreatePostView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = CreatePostViewModel.makeDefault()
    @State private var showErrorAlert: Bool = false
    @State private var showCancelAlert: Bool = false

    let onPostCreated: (() -> Void)?

    init(onPostCreated: (() -> Void)? = nil) {
        self.onPostCreated = onPostCreated
    }

    var body: some View {
        ZStack {
            backgroundDecoration

            VStack(spacing: 0) {
                writingGuideView
                textEditorView
                characterCountView
                Spacer()
            }
        }
        .background(Color.postBackground.ignoresSafeArea())
        .contentShape(Rectangle())
        .onTapGesture {
            hideKeyboard()
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .navigationTitle("새 게시글")
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    handleBackButton()
                }) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.textPrimary)
                }
            }

            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    Task {
                        await viewModel.createPost()
                    }
                }) {
                    Text("완료")
                        .font(.pretendard.mediumTextSemiBold)
                        .foregroundColor(viewModel.canPost && !viewModel.isOverMaxLength ? .orangeButton : .textSecondary)
                }
                .disabled(!viewModel.canPost || viewModel.isOverMaxLength)
            }
        }
        .onChange(of: viewModel.errorMessage) { errorMessage in
            if errorMessage != nil {
                showErrorAlert = true
            }
        }
        .onChange(of: viewModel.isPostCreated) { isCreated in
            if isCreated {
                onPostCreated?()
                dismiss()
            }
        }
        .onChange(of: viewModel.showTokenExpiredAlert) { isShowing in
            if !isShowing {
                dismiss()
            }
        }
        .customAlert(
            isPresented: $showErrorAlert,
            config: CustomAlertConfig(
                title: "오류",
                message: viewModel.errorMessage ?? "알 수 없는 오류가 발생했습니다.",
                primaryButton: AlertButton(title: "확인", style: .primary) {
                    viewModel.errorMessage = nil
                }
            )
        )
        .customAlert(
            isPresented: $showCancelAlert,
            config: CustomAlertConfig(
                message: "작성 중인 내용이 있습니다.\n정말 나가시겠습니까?",
                primaryButton: AlertButton(title: "나가기", style: .destructive) {
                    dismiss()
                },
                secondaryButton: AlertButton(title: "취소", style: .cancel)
            )
        )
        .tokenExpirationAlert(isPresented: $viewModel.showTokenExpiredAlert) {
            // 글쓰기 화면에서 나가기
            dismiss()
        }
        .overlay {
            if viewModel.isLoading {
                Color.black.opacity(0.3)
                    .ignoresSafeArea()

                ProgressView()
                    .tint(.orangeButton)
                    .scaleEffect(1.5)
            }
        }
    }

    // MARK: - Background Decoration
    private var backgroundDecoration: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Circle()
                    .fill(Color.orangeButton.opacity(0.05))
                    .frame(width: 200, height: 200)
                    .offset(x: 80, y: 80)
            }
        }
        .ignoresSafeArea()
    }

    // MARK: - Text Editor View
    private var textEditorView: some View {
        ZStack(alignment: .topLeading) {
            if viewModel.content.isEmpty {
                Text("무슨 생각을 하고 계신가요?")
                    .font(.pretendard.mediumTextRegular)
                    .foregroundColor(.textSecondary.opacity(0.5))
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
            }

            TextEditor(text: $viewModel.content)
                .font(.pretendard.mediumTextRegular)
                .foregroundColor(.textPrimary)
                .padding(.horizontal, 16)
                .padding(.top, 12)
                .scrollContentBackground(.hidden)
                .background(Color.clear)
        }
        .frame(minHeight: 200, maxHeight: 400)
        .padding(.top, 12)
    }

    // MARK: - Character Count View
    private var characterCountView: some View {
        HStack {
            Spacer()

            Text("\(viewModel.characterCount) / 500")
                .font(.pretendard.smallTextRegular)
                .foregroundColor(viewModel.isOverMaxLength ? .error : .textSecondary)
        }
        .padding(.horizontal, 20)
        .padding(.top, 8)
    }

    // MARK: - Writing Guide View
    private var writingGuideView: some View {
        VStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 8) {
                Text("✏️ 작성 팁")
                    .font(.pretendard.smallTextBold)
                    .foregroundColor(.textPrimary)

                VStack(alignment: .leading, spacing: 6) {
                    guideTipRow(icon: "💭", text: "솔직한 생각을 편하게 공유해보세요")
                    guideTipRow(icon: "🤝", text: "다른 사람을 존중하는 표현을 사용해주세요")
                    guideTipRow(icon: "✨", text: "긍정적인 에너지를 나눠보세요")
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 16)
            .padding(.bottom, 12)

            Divider()
                .background(Color.textSecondary.opacity(0.2))
                .padding(.horizontal, 20)
        }
    }

    private func guideTipRow(icon: String, text: String) -> some View {
        HStack(alignment: .top, spacing: 8) {
            Text(icon)
                .font(.system(size: 14))

            Text(text)
                .font(.pretendard.smallTextRegular)
                .foregroundColor(.textSecondary)
                .fixedSize(horizontal: false, vertical: true)
        }
    }

    // MARK: - Helper Methods
    private func handleBackButton() {
        if !viewModel.content.isEmpty {
            showCancelAlert = true
        } else {
            dismiss()
        }
    }

    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
