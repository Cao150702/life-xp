import SwiftUI

// MARK: - Color Tokens
extension Color {
    // Backgrounds
    static let bg = Color("bg")
    static let bg2 = Color("bg2")
    static let card = Color("card")
    static let card2 = Color("card2")
    static let card3 = Color("card3")
    static let border = Color("border")
    static let border2 = Color("border2")
    
    // Text
    static let textPrimary = Color("text")
    static let textSecondary = Color("text2")
    static let muted = Color("muted")
    
    // Brand
    static let brandPurple = Color("purple")
    static let brandPurple2 = Color("purple2")
    static let brandBlue = Color("blue")
    static let brandCyan = Color("cyan")
    static let brandGreen = Color("green")
    static let brandEmerald = Color("emerald")
    static let brandOrange = Color("orange")
    static let brandAmber = Color("amber")
    static let brandPink = Color("pink")
    static let brandRose = Color("rose")
    static let brandRed = Color("red")
}

// MARK: - Gradients
extension LinearGradient {
    static let brand = LinearGradient(
        colors: [.brandPurple, .brandBlue],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let success = LinearGradient(
        colors: [.brandEmerald, .brandGreen],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let gold = LinearGradient(
        colors: [.brandAmber, .brandOrange],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}

// MARK: - Spacing
enum Spacing {
    static let xs: CGFloat = 4
    static let sm: CGFloat = 8
    static let md: CGFloat = 12
    static let lg: CGFloat = 16
    static let xl: CGFloat = 20
    static let xxl: CGFloat = 24
    static let xxxl: CGFloat = 32
}

// MARK: - Corner Radius
enum CornerRadius {
    static let small: CGFloat = 14
    static let medium: CGFloat = 20
    static let large: CGFloat = 28
}

// MARK: - Category Color Helper
extension Color {
    static func forCategory(_ id: String) -> Color {
        switch id {
        case "study": return .brandPurple
        case "research": return .brandBlue
        case "code": return .brandCyan
        case "sport": return .brandGreen
        case "read": return .brandOrange
        case "express": return .brandPink
        default: return .brandPurple // custom categories use their own color
        }
    }
    
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default: (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

// MARK: - Rarity Colors
enum Rarity {
    case common, rare, epic, legendary
    
    var label: String {
        switch self {
        case .common: return "普通"
        case .rare: return "稀有"
        case .epic: return "史诗"
        case .legendary: return "传说"
        }
    }
    
    var bgColor: Color {
        switch self {
        case .common: return .brandBlue.opacity(0.15)
        case .rare: return .brandPurple.opacity(0.15)
        case .epic: return .brandPink.opacity(0.15)
        case .legendary: return .brandAmber.opacity(0.15)
        }
    }
    
    var textColor: Color {
        switch self {
        case .common: return .brandBlue
        case .rare: return .brandPurple
        case .epic: return .brandPink
        case .legendary: return .brandAmber
        }
    }
}
