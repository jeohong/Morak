//
//  PostHeaderView.swift
//  Morak
//
//  Created by 홍정민 on 11/4/25.
//

import SwiftUI

struct PostHeaderView: View {
    @ObservedObject var authManager: AuthManager
    @Binding var showLoginPrompt: Bool

    var body: some View {
        HStack(spacing: 12) {
            HStack(spacing: 6) {
                Image("logo")
                    .resizable()
                    .frame(width: 50, height: 50)
                
                Text("Morak")
                    .font(.pretendard.title)
                    .foregroundColor(.textPrimary)
            }
            
            Spacer()
            
            Button(action: {
                handleWriteButton()
            }) {
                HStack(spacing: 4) {
                    Text("✍️  글쓰기")
                        .font(.pretendard.smallTextBold)
                        .foregroundColor(.white)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(Color.orangeButton)
                .cornerRadius(20)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
        .background(Color.postBackground)
    }
    
    private func handleWriteButton() {
        // 로그인 상태 확인
        guard !authManager.requiresLogin else {
            showLoginPrompt = true
            return
        }

        // TODO: 글쓰기 화면 내비게이션 구현
        print("✍️ [PostHeaderView] 글쓰기 화면으로 이동")
    }
}
