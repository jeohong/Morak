//
//  ReportReasonSheet.swift
//  Morak
//
//  Created by Hong jeongmin on 12/26/25.
//

import SwiftUI

enum ReportReason: String, CaseIterable {
    case spam = "스팸/광고"
    case profanity = "욕설/비방"
    case obscenity = "음란물"
    case privacy = "개인정보 노출"
    case other = "기타"
}

struct ReportReasonSheet: View {
    let onReasonSelected: (String) -> Void
    let onCancel: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Text("신고 사유 선택")
                    .font(.pretendard.mediumTextSemiBold)
                    .foregroundColor(.textPrimary)

                Spacer()

                Button(action: onCancel) {
                    Image(systemName: "xmark")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.textSecondary)
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            .padding(.bottom, 16)

            Divider()

            // Reason List
            VStack(spacing: 0) {
                ForEach(ReportReason.allCases, id: \.self) { reason in
                    Button(action: {
                        onReasonSelected(reason.rawValue)
                    }) {
                        HStack {
                            Text(reason.rawValue)
                                .font(.pretendard.mediumTextRegular)
                                .foregroundColor(.textPrimary)

                            Spacer()

                            Image(systemName: "chevron.right")
                                .font(.system(size: 14))
                                .foregroundColor(.textSecondary)
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 16)
                    }

                    if reason != ReportReason.allCases.last {
                        Divider()
                            .padding(.leading, 20)
                    }
                }
            }

            Spacer()
        }
        .background(Color.cardBackground)
        .presentationDetents([.height(340)])
        .presentationDragIndicator(.visible)
    }
}
