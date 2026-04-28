import SwiftUI

// MARK: - Color Tokens (Pure Code, no Asset Catalog dependency)
extension Color {
    // Backgrounds
    static let bg = Color(red: 0.06, green: 0.06, blue: 0.08)
    static let bg2 = Color(red: 0.10, green: 0.10, blue: 0.13)
    static let card = Color(red: 0.13, green: 0.13, blue: 0.16)
    static let card2 = Color(red: 0.16, green: 0.16, blue: 0.19)
    static let card3 = Color(red: 0.19, green: 0.19, blue: 0.22)
    static let border = Color(red: 0.22, green: 0.22, blue: 0.25)
    static let border2 = Color(red: 0.28, green: 0.28, blue: 0.31)
    
    // Text
    static let textPrimary = Color(red: 0.92, green: 0.92, blue: 0.94)
    static let textSecondary = Color(red: 0.62, green: 0.62, blue: 0.66)
    static let muted = Color(red: 0.45, green: 0.45, blue: 0.48)
    
    // Brand
    static let brandPurple = Color(red: 0.55, green: 0.36, blue: 0.96)
    static let brandPurple2 = Color(red: 0.65, green: 0.45, blue: 1.00)
    static let brandBlue = Color(red: 0.23, green: 0.51, blue: 0.96)
    static let brandCyan = Color(red: 0.02, green: 0.71, blue: 0.83)
    static let brandGreen = Color(red: 0.06, green: 0.73, blue: 0.51)
    static let brandEmerald = Color(red: 0.16, green: 0.82, blue: 0.50)
    static let brandOrange = Color(red: 0.98, green: 0.62, blue: 0.12)
    static let brandAmber = Color(red: 0.96, green: 0.75, blue: 0.04)
    static let brandPink = Color(red: 0.93, green: 0.29, blue: 0.60)
    static let brandRose = Color(red: 0.96, green: 0.33, blue: 0.39)
    static let brandRed = Color(red: 0.91, green: 0.22, green: 0.21)
    
    // Semantic aliases
    static let brand = Color.brandPurple
    static let success = Color.brandEmerald
    static let warning = Color.brandAmber
    static let danger = Color.brandRed
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

// MARK: - Hex Initializer
extension Color {
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
        default: return .brandPurple
        }
    }
}

// MARK: - Rarity
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
    
    var glowColor: Color {
        switch self {
        case .common: return .brandBlue.opacity(0.3)
        case .rare: return .brandPurple.opacity(0.3)
        case .epic: return .brandPink.opacity(0.3)
        case .legendary: return .brandAmber.opacity(0.4)
        }
    }
}
