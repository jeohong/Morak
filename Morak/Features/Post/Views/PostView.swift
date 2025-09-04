//
//  PostView.swift
//  Morak
//
//  Created by Hong jeongmin on 8/12/25.
//

import SwiftUI

struct PostView: View {
    var body: some View {
        VStack(spacing: 0) {
            HeaderView()
            
            GeometryReader { geometry in
                ScrollView {
                    VStack {
                        Text("포스트 뷰")
                    }
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
        }
        .background(Color.background.ignoresSafeArea())
    }
}

#Preview {
    PostView()
}
