//
//  FilterPickerSheet.swift
//  Morak
//
//  Created by Hong jeongmin on 8/29/25.
//

import SwiftUI

struct FilterPickerSheet: View {
    @Binding var isPresented: Bool
    @Binding var selectedFilter: FilterOption
    @State private var tempSelection: FilterOption
    let onConfirm: (FilterOption) -> Void
    
    init(isPresented: Binding<Bool>, 
         selectedFilter: Binding<FilterOption>,
         onConfirm: @escaping (FilterOption) -> Void) {
        self._isPresented = isPresented
        self._selectedFilter = selectedFilter
        self._tempSelection = State(initialValue: selectedFilter.wrappedValue)
        self.onConfirm = onConfirm
    }
    
    var body: some View {
        VStack {
            SheetHeader(
                title: "정렬 기준",
                onCancel: {
                    isPresented = false
                },
                onConfirm: {
                    if selectedFilter != tempSelection {
                        selectedFilter = tempSelection
                        onConfirm(tempSelection)
                    }
                    isPresented = false
                }
            )
            
            Picker(selection: $tempSelection, label: EmptyView()) {
                ForEach(FilterOption.allCases, id: \.self) { option in
                    Text(option.title)
                        .tag(option)
                        .font(.pretendard.largeTextRegular)
                }
            }
            .pickerStyle(WheelPickerStyle())
        }
        .presentationDetents([.height(250)])
    }
}

private struct SheetHeader: View {
    let title: String
    let onCancel: () -> Void
    let onConfirm: () -> Void
    
    var body: some View {
        HStack {
            Button("취소", action: onCancel)
                .font(.pretendard.largeTextMedium)
                .padding()
            
            Spacer()
            
            Text(title)
                .font(.pretendard.largeTextMedium)
            
            Spacer()
            
            Button("완료", action: onConfirm)
                .font(.pretendard.largeTextMedium)
                .padding()
        }
    }
}
