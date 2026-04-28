import SwiftUI

struct HomeView: View {
    @EnvironmentObject var authVM: AuthViewModel
    @State private var todayXP = 0
    @State private var todayMinutes = 0
    @State private var streak = 0
    @State private var totalXP = 0
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: Spacing.xl) {
                    // Hero Card
                    heroCard
                    
                    // Stats Row
                    statsRow
                    
                    // Skills Grid
                    skillsSection
                    
                    // Today's Logs
                    todayLogsSection
                }
                .padding(Spacing.lg)
            }
            .background(Color.bg)
            .navigationTitle("LifeQuest")
            .navigationBarTitleDisplayMode(.inline)
        }
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
            Text("今日记录")
                .font(.headline)
            
            VStack(spacing: Spacing.sm) {
                // Placeholder
                HStack {
                    Spacer()
                    VStack(spacing: 8) {
                        Text("📝")
                            .font(.system(size: 40))
                        Text("今天还没有记录")
                            .foregroundStyle(.textSecondary)
                        Text("点击「记录」开始打卡")
                            .font(.caption)
                            .foregroundStyle(.muted)
                    }
                    Spacer()
                }
                .frame(height: 120)
            }
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
