//
//  FilterSectionView.swift
//  Morak
//
//  Created by 홍정민 on 11/7/25.
//

import SwiftUI

struct FilterSectionView: View {
    @Binding var selectedFilter: FilterOption
    let onFilterChange: (FilterOption) -> Void
    
    var body: some View {
        HStack(spacing: 12) {
            Menu {
                ForEach(FilterOption.allCases, id: \.self) { option in
                    Button(action: {
                        selectedFilter = option
                        onFilterChange(option)
                    }) {
                        HStack {
                            Text(option.title)
                            if selectedFilter == option {
                                Image(systemName: "checkmark")
                            }
                        }
                    }
                }
            } label: {
                HStack(spacing: 8) {
                    Image(systemName: "line.3.horizontal.decrease.circle")
                        .font(.system(size: 16))
                        .foregroundColor(.textSecondary)
                    
                    Text(selectedFilter.title)
                        .font(.pretendard.mediumTextRegular)
                        .foregroundColor(.textPrimary)
                    
                    Image(systemName: "chevron.down")
                        .font(.system(size: 10))
                        .foregroundColor(.textSecondary)
                }
                .padding(.horizontal, 14)
                .padding(.vertical, 10)
                .background(Color.cardBackground)
                .cornerRadius(20)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.textSecondary.opacity(0.2), lineWidth: 1)
                )
            }

            Spacer()

            // TODO: 검색 기능 추가 시 활성화
            // Button(action: {
            //     print("검색")
            // }) {
            //     Image(systemName: "magnifyingglass")
            //         .font(.system(size: 16))
            //         .foregroundColor(.textSecondary)
            //         .frame(width: 40, height: 40)
            //         .background(Color.cardBackground)
            //         .cornerRadius(20)
            //         .overlay(
            //             RoundedRectangle(cornerRadius: 20)
            //                 .stroke(Color.textSecondary.opacity(0.2), lineWidth: 1)
            //         )
            // }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
    }
}
