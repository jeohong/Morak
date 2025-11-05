//
//  CustomAlert.swift
//  Morak
//
//  Created by Hong jeongmin on 11/5/25.
//

import SwiftUI

// MARK: - Alert Configuration
struct CustomAlertConfig {
    let title: String?
    let message: String
    let primaryButton: AlertButton
    let secondaryButton: AlertButton?

    init(
        title: String? = nil,
        message: String,
        primaryButton: AlertButton,
        secondaryButton: AlertButton? = nil
    ) {
        self.title = title
        self.message = message
        self.primaryButton = primaryButton
        self.secondaryButton = secondaryButton
    }
}

// MARK: - Alert Button
struct AlertButton {
    let title: String
    let style: ButtonStyle
    let action: () -> Void

    enum ButtonStyle {
        case primary    // 주황색 배경
        case secondary  // 회색 배경
        case destructive // 빨간색 배경
        case cancel     // 테두리만
    }

    init(title: String, style: ButtonStyle = .primary, action: @escaping () -> Void = {}) {
        self.title = title
        self.style = style
        self.action = action
    }
}

// MARK: - Custom Alert View
struct CustomAlertView: View {
    let config: CustomAlertConfig
    @Binding var isPresented: Bool

    var body: some View {
        ZStack {
            // 배경 딤 처리
            Color.black.opacity(0.4)
                .ignoresSafeArea(.all)
                .onTapGesture {
                    // 배경 탭하면 닫기
                    isPresented = false
                }

            // Alert 컨텐츠
            VStack(spacing: 0) {
                // 제목 (옵셔널)
                if let title = config.title {
                    Text(title)
                        .font(.pretendard.largeTextBold)
                        .foregroundColor(.textPrimary)
                        .padding(.top, 24)
                        .padding(.horizontal, 24)
                }

                // 메시지
                Text(config.message)
                    .font(.pretendard.mediumTextRegular)
                    .foregroundColor(.textSecondary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
                    .padding(.top, config.title == nil ? 24 : 12)
                    .padding(.horizontal, 24)

                // 버튼 영역
                if let secondaryButton = config.secondaryButton {
                    // 2개 버튼 (가로 배치)
                    HStack(spacing: 12) {
                        alertButton(secondaryButton)
                        alertButton(config.primaryButton)
                    }
                    .padding(.top, 24)
                    .padding(.horizontal, 24)
                    .padding(.bottom, 24)
                } else {
                    // 1개 버튼
                    alertButton(config.primaryButton)
                        .padding(.top, 24)
                        .padding(.horizontal, 24)
                        .padding(.bottom, 24)
                }
            }
            .frame(maxWidth: 320)
            .background(Color.cardBackground)
            .cornerRadius(16)
            .shadow(color: .black.opacity(0.15), radius: 20, x: 0, y: 10)
        }
    }

    @ViewBuilder
    private func alertButton(_ button: AlertButton) -> some View {
        Button(action: {
            button.action()
            isPresented = false
        }) {
            Text(button.title)
                .font(.pretendard.mediumTextSemiBold)
                .foregroundColor(buttonForegroundColor(for: button.style))
                .frame(maxWidth: .infinity)
                .frame(height: 48)
                .background(buttonBackgroundColor(for: button.style))
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(buttonBorderColor(for: button.style), lineWidth: button.style == .cancel ? 1.5 : 0)
                )
        }
    }

    private func buttonBackgroundColor(for style: AlertButton.ButtonStyle) -> Color {
        switch style {
        case .primary:
            return .main
        case .secondary:
            return .lightGray
        case .destructive:
            return .customRed
        case .cancel:
            return .clear
        }
    }

    private func buttonForegroundColor(for style: AlertButton.ButtonStyle) -> Color {
        switch style {
        case .primary, .destructive:
            return .white
        case .secondary:
            return .textPrimary
        case .cancel:
            return .textSecondary
        }
    }

    private func buttonBorderColor(for style: AlertButton.ButtonStyle) -> Color {
        switch style {
        case .cancel:
            return .textSecondary.opacity(0.3)
        default:
            return .clear
        }
    }
}

// MARK: - View Extension for Easy Usage
extension View {
    func customAlert(isPresented: Binding<Bool>, config: CustomAlertConfig) -> some View {
        ZStack {
            self

            if isPresented.wrappedValue {
                CustomAlertView(config: config, isPresented: isPresented)
                    .transition(.opacity.animation(.easeInOut(duration: 0.2)))
                    .zIndex(999)
            }
        }
    }
}

// MARK: - Preview
#Preview("Single Button") {
    VStack {
        Text("Main Content")
    }
    .customAlert(
        isPresented: .constant(true),
        config: CustomAlertConfig(
            title: "알림",
            message: "포스트를 불러오는 중 오류가 발생했습니다.",
            primaryButton: AlertButton(title: "확인", style: .primary)
        )
    )
}

#Preview("Two Buttons") {
    VStack {
        Text("Main Content")
    }
    .customAlert(
        isPresented: .constant(true),
        config: CustomAlertConfig(
            title: "로그아웃",
            message: "정말 로그아웃 하시겠습니까?",
            primaryButton: AlertButton(title: "로그아웃", style: .destructive),
            secondaryButton: AlertButton(title: "취소", style: .cancel)
        )
    )
}

#Preview("No Title") {
    VStack {
        Text("Main Content")
    }
    .customAlert(
        isPresented: .constant(true),
        config: CustomAlertConfig(
            message: "로그인이 필요한 기능입니다.\n로그인 페이지로 이동하시겠습니까?",
            primaryButton: AlertButton(title: "로그인", style: .primary),
            secondaryButton: AlertButton(title: "취소", style: .cancel)
        )
    )
}
