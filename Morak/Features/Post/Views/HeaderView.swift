//
//  HeaderView.swift
//  Morak
//
//  Created by 홍정민 on 8/27/25.
//

import SwiftUI

struct HeaderView: View {
    @State private var showFilterMenu = false
    @State private var selectedFilter: FilterOption = .latest
    
    var body: some View {
        HStack {
            LogoSection()
            Spacer()
            ActionButtons(
                showFilterMenu: $showFilterMenu,
                selectedFilter: $selectedFilter
            )
        }
        .padding(.horizontal, 20)
    }
}

// MARK: - Logo Section
private struct LogoSection: View {
    var body: some View {
        HStack {
            Image("logo")
                .resizable()
                .frame(width: 50, height: 50)
            
            Text("Morak")
                .font(.pretendard.largeTitle)
                .foregroundStyle(Color.surface)
        }
    }
}

// MARK: - Action Buttons
private struct ActionButtons: View {
    @Binding var showFilterMenu: Bool
    @Binding var selectedFilter: FilterOption
    
    var body: some View {
        HStack(spacing: 10) {
            HeaderButton(imageName: "ic_bell") {
                print("알림")
            }
            
            HeaderButton(imageName: "ic_search") {
                print("검색")
            }
            
            HeaderButton(imageName: "ic_filter") {
                showFilterMenu = true
            }
            .sheet(isPresented: $showFilterMenu) {
                FilterPickerSheet(
                    isPresented: $showFilterMenu,
                    selectedFilter: $selectedFilter,
                    onConfirm: { filter in
                        // TODO: ViewModel 연결해서 API 재호출
                        print("\(filter.title) 선택됨")
                    }
                )
            }
        }
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
