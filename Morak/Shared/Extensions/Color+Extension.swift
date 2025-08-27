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
    static var main: Color { Color(hex: 0xFFAD35) }
    static var deepGray: Color { Color(hex: 0x5A554E) }
    static var customRed: Color { Color(hex: 0xFF0000) }
    static var point: Color { Color(hex: 0xFF8424) }
    static var lightYellow: Color { Color(hex: 0xFEEDBF) }
    
    // MARK: - Semantic Colors (의미적 색상)
    static var primary: Color { .main }
    static var secondary: Color { .point }
    static var surface: Color { .lightYellow }
    static var textPrimary: Color { .black }
    static var textSecondary: Color { .deepGray }
    static var error: Color { .customRed }
}
