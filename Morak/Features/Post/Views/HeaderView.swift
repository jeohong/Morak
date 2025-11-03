//
//  HeaderView.swift
//  Morak
//
//  Created by 홍정민 on 8/27/25.
//

import SwiftUI

struct PostHeaderView: View {
    var body: some View {
        HStack(spacing: 12) {
            // 왼쪽: 로고
            HStack(spacing: 6) {
                Image("logo")
                    .resizable()
                    .frame(width: 50, height: 50)
                
                Text("Morak")
                    .font(.pretendard.title)
                    .foregroundColor(.textPrimary)
            }

            Spacer()

            // 오른쪽: 글쓰기 버튼
            Button(action: {
                print("글쓰기")
            }) {
                HStack(spacing: 4) {
                    Text("✍️")
                        .font(.system(size: 14))
                    Text("글쓰기")
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
}
