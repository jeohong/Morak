import SwiftUI

extension Font {
    static var pretendard: PretendardFont { return PretendardFont() }
    
    struct PretendardFont {
        private let familyName = "Pretendard"
        
        var title: Font { return font(for: 18, weight: .bold) }
        
        var largeTextBold: Font { return font(for: 16, weight: .bold) }
        var largeTextMedium: Font { return font(for: 16, weight: .medium) }
        var largeTextRegular: Font { return font(for: 16, weight: .regular) }
        
        var mediumTextSemiBold: Font { return font(for: 14, weight: .semibold) }
        var mediumTextRegular: Font { return font(for: 14, weight: .regular) }
        
        var smallTextBold: Font { return font(for: 12, weight: .bold) }
        var smallTextRegular: Font { return font(for: 12, weight: .regular) }
        
        var tinyTextBold: Font { return font(for: 10, weight: .semibold) }
        var tinyText: Font { return font(for: 10, weight: .regular) }
        
        var largeTitle: Font { return font(for: 40, weight: .semibold) }
        
        private func font(for size: CGFloat, weight: Font.Weight) -> Font {
            let weightString: String
            
            switch weight {
            case .black:
                weightString = "Black"
            case .bold:
                weightString = "Bold"
            case .heavy:
                weightString = "Heavy"
            case .ultraLight:
                weightString = "UltraLight"
            case .light:
                weightString = "Light"
            case .medium:
                weightString = "Medium"
            case .regular:
                weightString = "Regular"
            case .semibold:
                weightString = "SemiBold"
            case .thin:
                weightString = "Thin"
            default:
                weightString = "Regular"
            }
            
            return Font.custom("\(familyName)-\(weightString)", size: size)
        }
    }
}