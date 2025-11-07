//
//  View+Extension.swift
//  Morak
//
//  Created by Hong jeongmin on 11/7/25.
//

import SwiftUI

extension View {
    /// 토큰 만료(장기 미접속) 알림 팝업
    /// - Parameters:
    ///   - isPresented: 팝업 표시 여부
    ///   - onConfirm: 확인 버튼 클릭 시 실행할 클로저 (optional)
    func tokenExpirationAlert(
        isPresented: Binding<Bool>,
        onConfirm: (() -> Void)? = nil
    ) -> some View {
        self.customAlert(
            isPresented: isPresented,
            config: CustomAlertConfig(
                message: "장기 미접속으로 로그아웃 되었습니다",
                primaryButton: AlertButton(title: "확인", style: .primary) {
                    onConfirm?()
                }
            )
        )
    }
}
