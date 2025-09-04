//
//  Color+Extension.swift
//  Morak
//
//  Created by Hong jeongmin on 8/22/25.
//

import SwiftUI

// MARK: - Hex Color Initializer
extension Color {
    init(hex: UInt, alpha: Double = 1) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xff) / 255,
            green: Double((hex >> 08) & 0xff) / 255,
            blue: Double((hex >> 00) & 0xff) / 255,
            opacity: alpha
        )
    }
}

// MARK: - Custom Colors Extension
extension Color {
    // MARK: - Base Colors
    static var main: Color { Color(hex: 0xff6b35) }
    static var deepGray: Color { Color(hex: 0x5A554E) }
    static var customRed: Color { Color(hex: 0xFF0000) }
    static var point: Color { Color(hex: 0xfef8f4) }
    static var whiteColor: Color { Color(hex: 0xfffefd) }
    
    // MARK: - Semantic Colors (의미적 색상)
    static var primary: Color { .main }
    static var background: Color { .point }
    static var textSecondary: Color { .deepGray }
    static var error: Color { .customRed }
    static var tabBackground: Color { .whiteColor }
}
