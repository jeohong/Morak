//
//  HeaderView.swift
//  Morak
//
//  Created by 홍정민 on 8/27/25.
//

import SwiftUI

struct HeaderView: View {
    var body: some View {
        HStack {
            Image("logo")
                .resizable()
                .frame(width: 50, height: 50)
            
            Text("Morak")
                .font(.pretendard.largeTitle)
                .foregroundStyle(Color.surface)
            
            Spacer()
            
            HStack(spacing: 10) {
                HeaderButton(imageName: "ic_bell") {
                    print("알림")
                }
                
                HeaderButton(imageName: "ic_search") {
                    print("검색")
                }
                
                HeaderButton(imageName: "ic_filter") {
                    print("필터")
                }
            }
        }
        .padding(.horizontal, 20)
    }
}

struct HeaderButton: View {
    let imageName: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(imageName)
                .resizable()
                .frame(width: 30, height: 30)
        }
    }
}

#Preview {
    HeaderView()
}
