import Foundation

// MARK: - Level System

enum LevelSystem {
    static let thresholds = [
        0, 100, 250, 450, 700, 1050, 1500, 2100, 2900, 3900,
        5200, 6800, 8700, 11000, 13800, 17000, 21000, 26000,
        32000, 40000, 50000, 62000, 76000, 92000, 110000
    ]
    
    static let classNames = [
        "学徒", "学者", "研究员", "专家", "精英",
        "大师", "宗师", "传说", "神话", "至圣", "创世者"
    ]
    
    static func level(for xp: Int) -> Int {
        for i in stride(from: thresholds.count - 1, through: 0, by: -1) {
            if xp >= thresholds[i] { return i + 1 }
        }
        return 1
    }
    
    static func classFor(level: Int) -> String {
        let index = min(Int(floor(Double(level - 1) / 2.5)), classNames.count - 1)
        return classNames[index]
    }
    
    struct LevelInfo {
        let level: Int
        let currentThreshold: Int
        let nextThreshold: Int
        let progress: Double
        let remaining: Int
        
        init(xp: Int) {
            self.level = LevelSystem.level(for: xp)
            self.currentThreshold = LevelSystem.thresholds[self.level - 1]
            self.nextThreshold = LevelSystem.thresholds.indices.contains(self.level)
                ? LevelSystem.thresholds[self.level]
                : Int(Double(self.currentThreshold) * 1.5)
            let range = self.nextThreshold - self.currentThreshold
            let earned = xp - self.currentThreshold
            self.progress = range > 0 ? min(Double(earned) / Double(range), 1.0) : 1.0
            self.remaining = max(self.nextThreshold - xp, 0)
        }
    }
}

// MARK: - Categories

struct Category: Identifiable, Codable, Hashable {
    let id: String
    let name: String
    let icon: String
    let color: String
    let xpPerMin: Int
    let desc: String
    let isCustom: Bool
    
    static let builtIn: [Category] = [
        Category(id: "study", name: "学习", icon: "📚", color: "#8B5CF6", xpPerMin: 3, desc: "读书、上课、复习", isCustom: false),
        Category(id: "research", name: "科研", icon: "🔬", color: "#3B82F6", xpPerMin: 4, desc: "实验、论文、课题", isCustom: false),
        Category(id: "code", name: "编程", icon: "💻", color: "#06B6D4", xpPerMin: 4, desc: "写代码、debug、项目", isCustom: false),
        Category(id: "sport", name: "运动", icon: "🏃", color: "#10B981", xpPerMin: 2, desc: "跑步、健身、球类", isCustom: false),
        Category(id: "read", name: "阅读", icon: "📖", color: "#F59E0B", xpPerMin: 2, desc: "课外书、文章、博客", isCustom: false),
        Category(id: "express", name: "表达", icon: "🎤", color: "#EC4899", xpPerMin: 3, desc: "写作、演讲、分享", isCustom: false),
    ]
    
    static let avatars = ["🧑‍💻","👩‍🎓","🧑‍🔬","🧑‍🎨","🧙","🦸","🐉","🎮","🧑‍🚀","🦊","🐱","🦁"]
}

// MARK: - Achievement

struct Achievement: Identifiable {
    let id: String
    let icon: String
    let name: String
    let desc: String
    let rarity: Rarity
    
    static let all: [Achievement] = [
        Achievement(id: "first", icon: "🌱", name: "破壳而出", desc: "完成第一次打卡", rarity: .common),
        Achievement(id: "log10", icon: "📝", name: "初露锋芒", desc: "累计打卡 10 次", rarity: .common),
        Achievement(id: "log50", icon: "⚡", name: "勤奋之星", desc: "累计打卡 50 次", rarity: .rare),
        Achievement(id: "log100", icon: "💎", name: "百炼成钢", desc: "累计打卡 100 次", rarity: .rare),
        Achievement(id: "log500", icon: "🏅", name: "千锤百炼", desc: "累计打卡 500 次", rarity: .epic),
        Achievement(id: "streak3", icon: "🔥", name: "三连击", desc: "连续打卡 3 天", rarity: .common),
        Achievement(id: "streak7", icon: "🌟", name: "一周达人", desc: "连续打卡 7 天", rarity: .rare),
        Achievement(id: "streak14", icon: "💫", name: "两周坚持", desc: "连续打卡 14 天", rarity: .rare),
        Achievement(id: "streak30", icon: "👑", name: "月度王者", desc: "连续打卡 30 天", rarity: .epic),
        Achievement(id: "streak60", icon: "🏆", name: "双月传奇", desc: "连续打卡 60 天", rarity: .epic),
        Achievement(id: "streak100", icon: "🔱", name: "百日筑基", desc: "连续打卡 100 天", rarity: .legendary),
        Achievement(id: "xp500", icon: "✨", name: "初窥门径", desc: "总经验达到 500", rarity: .common),
        Achievement(id: "xp2k", icon: "🥈", name: "小有所成", desc: "总经验达到 2000", rarity: .rare),
        Achievement(id: "xp5k", icon: "🥇", name: "成果丰硕", desc: "总经验达到 5000", rarity: .rare),
        Achievement(id: "xp20k", icon: "💎", name: "大器晚成", desc: "总经验达到 20000", rarity: .epic),
        Achievement(id: "xp50k", icon: "🌟", name: "登峰造极", desc: "总经验达到 50000", rarity: .legendary),
        Achievement(id: "lv5", icon: "⚔️", name: "小试牛刀", desc: "角色达到 5 级", rarity: .common),
        Achievement(id: "lv10", icon: "🐉", name: "实力进阶", desc: "角色达到 10 级", rarity: .rare),
        Achievement(id: "lv20", icon: "🔥", name: "巅峰之路", desc: "角色达到 20 级", rarity: .epic),
        Achievement(id: "hr2", icon: "⏰", name: "深度专注", desc: "单次专注超 2 小时", rarity: .rare),
        Achievement(id: "variety", icon: "🌈", name: "全面发展", desc: "所有类别都有记录", rarity: .epic),
        Achievement(id: "night", icon: "🌙", name: "夜猫子", desc: "22:00 后打卡", rarity: .common),
        Achievement(id: "morning", icon: "🌅", name: "早起鸟", desc: "06:00 前打卡", rarity: .common),
        Achievement(id: "day1k", icon: "💪", name: "日进千XP", desc: "单日经验超过 1000", rarity: .epic),
    ]
}

// MARK: - Utility Functions

func fmtNum(_ n: Int) -> String {
    if n >= 10000 { return String(format: "%.1fw", Double(n) / 10000.0) }
    if n >= 1000 { return String(format: "%.1fk", Double(n) / 1000.0) }
    return String(n)
}
