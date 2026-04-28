import SwiftUI

struct HomeView: View {
    @EnvironmentObject var authVM: AuthViewModel
    var onRecordTap: (() -> Void)? = nil
    @State private var todayXP = 0
    @State private var todayMinutes = 0
    @State private var streak = 0
    @State private var totalXP = 0
    @State private var todayLogs: [LogEntry] = []
    
    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: Spacing.xl) {
                    // Greeting
                    greetingHeader
                    
                    // Hero Card
                    heroCard
                    
                    // Stats Row
                    statsRow
                    
                    // Skills Grid
                    skillsSection
                    
                    // Today's Logs
                    todayLogsSection
                    
                    // Bottom spacer for tab bar + floating button
                    Color.clear.frame(height: 80)
                }
                .padding(.horizontal, Spacing.lg)
            }
            .background(Color.bg)
            .navigationBarHidden(true)
        }
    }
    
    // MARK: - Greeting
    private var greetingHeader: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(greetingText)
                    .font(.title2.weight(.bold))
                Text(dateString)
                    .font(.subheadline)
                    .foregroundStyle(.textSecondary)
            }
            Spacer()
        }
        .padding(.top, Spacing.md)
    }
    
    private var greetingText: String {
        let hour = Calendar.current.component(.hour, from: Date())
        if hour < 6 { return "夜深了 🌙" }
        if hour < 9 { return "早上好 ☀️" }
        if hour < 12 { return "上午好 🌤" }
        if hour < 14 { return "中午好 🍱" }
        if hour < 18 { return "下午好 ☕" }
        if hour < 22 { return "晚上好 🌆" }
        return "夜深了 🌙"
    }
    
    private var dateString: String {
        let fmt = DateFormatter()
        fmt.locale = Locale(identifier: "zh_CN")
        fmt.dateFormat = "M月d日 EEEE"
        return fmt.string(from: Date())
    }
    
    // MARK: - Hero Card
    private var heroCard: some View {
        VStack(spacing: Spacing.md) {
            HStack {
                Text(authVM.userAvatar)
                    .font(.system(size: 48))
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(authVM.userName)
                        .font(.title3.weight(.bold))
                    
                    Text("✦ \(LevelSystem.classFor(level: LevelSystem.level(for: totalXP))) ✦")
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.brandPurple2)
                }
                
                Spacer()
                
                // Level Badge
                VStack(spacing: 2) {
                    Text("Lv")
                        .font(.caption2.weight(.bold))
                        .foregroundStyle(.muted)
                    Text("\(LevelSystem.level(for: totalXP))")
                        .font(.system(size: 32, weight: .black, design: .rounded))
                        .foregroundStyle(.brand)
                }
            }
            
            // XP Progress Bar
            VStack(alignment: .leading, spacing: 6) {
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        Rectangle()
                            .fill(Color.bg2)
                            .frame(height: 8)
                            .clipShape(Capsule())
                        
                        Rectangle()
                            .fill(.brand)
                            .frame(width: geo.size.width * LevelSystem.LevelInfo(xp: totalXP).progress, height: 8)
                            .clipShape(Capsule())
                    }
                }
                .frame(height: 8)
                
                HStack {
                    Text("\(fmtNum(totalXP - LevelSystem.LevelInfo(xp: totalXP).currentThreshold)) / \(fmtNum(LevelSystem.LevelInfo(xp: totalXP).nextThreshold - LevelSystem.LevelInfo(xp: totalXP).currentThreshold))")
                        .font(.caption.weight(.medium))
                        .foregroundStyle(.muted)
                    Spacer()
                    Text("还差 \(fmtNum(LevelSystem.LevelInfo(xp: totalXP).remaining)) XP")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.brandPurple2)
                }
            }
        }
        .padding(Spacing.xl)
        .background(
            RoundedRectangle(cornerRadius: CornerRadius.large)
                .fill(Color.card)
                .overlay(
                    RoundedRectangle(cornerRadius: CornerRadius.large)
                        .stroke(Color.border, lineWidth: 1)
                )
        )
    }
    
    // MARK: - Stats Row
    private var statsRow: some View {
        HStack(spacing: Spacing.md) {
            StatCard(title: "今日 XP", value: "\(fmtNum(todayXP))", icon: "⚡", color: .brandEmerald)
            StatCard(title: "今日分钟", value: "\(fmtNum(todayMinutes))", icon: "⏱", color: .brandBlue)
            StatCard(title: "连续天数", value: "\(streak)", icon: "🔥", color: .brandAmber)
        }
    }
    
    // MARK: - Skills
    private var skillsSection: some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            Text("技能等级")
                .font(.headline)
            
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: Spacing.md) {
                ForEach(Category.builtIn) { cat in
                    SkillCard(category: cat, xp: 0) // TODO: fetch actual XP
                }
            }
        }
    }
    
    // MARK: - Today's Logs
    private var todayLogsSection: some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            HStack {
                Text("今日记录")
                    .font(.headline)
                Spacer()
                if !todayLogs.isEmpty {
                    Text("\(todayLogs.count) 条")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.brandPurple)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Capsule().fill(Color.brandPurple.opacity(0.12)))
                }
            }
            
            if todayLogs.isEmpty {
                // Empty state
                HStack {
                    Spacer()
                    VStack(spacing: 12) {
                        Text("📝")
                            .font(.system(size: 40))
                        Text("今天还没有记录")
                            .font(.subheadline.weight(.medium))
                            .foregroundStyle(.textSecondary)
                        Text("点击底部 + 开始打卡")
                            .font(.caption)
                            .foregroundStyle(.muted)
                    }
                    Spacer()
                }
                .frame(height: 140)
                .background(
                    RoundedRectangle(cornerRadius: CornerRadius.small)
                        .fill(Color.card)
                        .overlay(
                            RoundedRectangle(cornerRadius: CornerRadius.small)
                                .strokeBorder(style: StrokeStyle(lineWidth: 1, dash: [6]))
                                .foregroundStyle(Color.border)
                        )
                )
            } else {
                ForEach(todayLogs) { log in
                    LogRowView(log: log)
                }
            }
        }
    }
}

// MARK: - Log Entry

struct LogEntry: Identifiable {
    let id = UUID()
    let icon: String
    let name: String
    let title: String
    let duration: Int
    let xp: Int
    let time: String
    let color: String
}

// MARK: - Log Row View

struct LogRowView: View {
    let log: LogEntry
    
    var body: some View {
        HStack(spacing: Spacing.md) {
            // Category icon
            Text(log.icon)
                .font(.title3)
                .frame(width: 40, height: 40)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color(hex: log.color).opacity(0.12))
                )
            
            // Info
            VStack(alignment: .leading, spacing: 3) {
                HStack {
                    Text(log.name)
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(Color(hex: log.color))
                    Text("·")
                        .foregroundStyle(.muted)
                    Text(log.time)
                        .font(.caption)
                        .foregroundStyle(.muted)
                }
                Text(log.title)
                    .font(.subheadline.weight(.medium))
                    .lineLimit(1)
            }
            
            Spacer()
            
            // XP badge
            VStack(alignment: .trailing, spacing: 2) {
                Text("+\(log.xp)")
                    .font(.subheadline.weight(.bold).monospacedDigit())
                    .foregroundStyle(.brandEmerald)
                Text("\(log.duration)min")
                    .font(.system(size: 10))
                    .foregroundStyle(.muted)
            }
        }
        .padding(Spacing.lg)
        .background(
            RoundedRectangle(cornerRadius: CornerRadius.small)
                .fill(Color.card)
                .overlay(
                    RoundedRectangle(cornerRadius: CornerRadius.small)
                        .stroke(Color.border, lineWidth: 1)
                )
        )
    }
}
}

// MARK: - Stat Card

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: Spacing.sm) {
            Text(icon)
                .font(.title2)
            Text(value)
                .font(.title2.weight(.black).monospacedDigit())
            Text(title)
                .font(.caption.weight(.semibold))
                .foregroundStyle(.muted)
        }
        .frame(maxWidth: .infinity)
        .padding(Spacing.lg)
        .background(
            RoundedRectangle(cornerRadius: CornerRadius.small)
                .fill(Color.card)
                .overlay(
                    RoundedRectangle(cornerRadius: CornerRadius.small)
                        .stroke(Color.border, lineWidth: 1)
                )
        )
    }
}

// MARK: - Skill Card

struct SkillCard: View {
    let category: Category
    let xp: Int
    
    private var levelInfo: LevelSystem.LevelInfo {
        LevelSystem.LevelInfo(xp: xp)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            HStack {
                Text(category.icon)
                    .font(.title3)
                    .frame(width: 40, height: 40)
                    .background(
                        Circle()
                            .fill(Color(hex: category.color).opacity(0.1))
                    )
                
                VStack(alignment: .leading) {
                    Text(category.name)
                        .font(.subheadline.weight(.semibold))
                    Text("Lv\(levelInfo.level)")
                        .font(.caption.weight(.bold).monospacedDigit())
                        .foregroundStyle(Color(hex: category.color))
                }
                
                Spacer()
            }
            
            // Progress bar
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(Color.bg2)
                        .frame(height: 4)
                        .clipShape(Capsule())
                    
                    Rectangle()
                        .fill(Color(hex: category.color))
                        .frame(width: geo.size.width * levelInfo.progress, height: 4)
                        .clipShape(Capsule())
                }
            }
            .frame(height: 4)
            
            Text("\(fmtNum(xp)) XP")
                .font(.caption2)
                .foregroundStyle(.muted)
        }
        .padding(Spacing.lg)
        .background(
            RoundedRectangle(cornerRadius: CornerRadius.small)
                .fill(Color.card)
                .overlay(
                    RoundedRectangle(cornerRadius: CornerRadius.small)
                        .stroke(Color.border, lineWidth: 1)
                )
        )
        .overlay(alignment: .top) {
            Rectangle()
                .fill(Color(hex: category.color))
                .frame(height: 2)
                .clipShape(UnevenRoundedRectangle(topLeadingRadius: CornerRadius.small, topTrailingRadius: CornerRadius.small))
        }
    }
}
