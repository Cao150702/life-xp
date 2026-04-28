import SwiftUI

struct AchievementsView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: Spacing.xl) {
                    // Stats
                    HStack(spacing: Spacing.md) {
                        AchievementStatView(value: "0", label: "已解锁", color: .brandAmber)
                        AchievementStatView(value: "\(Achievement.all.count)", label: "总成就", color: .brandPurple)
                        AchievementStatView(value: "0%", label: "完成度", color: .brandCyan)
                    }
                    
                    // Achievement Grid
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: Spacing.md) {
                        ForEach(Achievement.all) { ach in
                            AchievementCard(achievement: ach, isUnlocked: false, progress: 0, max: 1)
                        }
                    }
                }
                .padding(Spacing.lg)
            }
            .background(Color.bg)
            .navigationTitle("成就")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct AchievementStatView: View {
    let value: String
    let label: String
    let color: Color
    
    var body: some View {
        VStack(spacing: Spacing.xs) {
            Text(value)
                .font(.system(size: 28, weight: .black).monospacedDigit())
                .foregroundStyle(color)
            Text(label)
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

struct AchievementCard: View {
    let achievement: Achievement
    let isUnlocked: Bool
    let progress: Int
    let max: Int
    
    var body: some View {
        VStack(spacing: Spacing.sm) {
            // Rarity Badge
            HStack {
                Spacer()
                Text(achievement.rarity.label)
                    .font(.system(size: 9, weight: .bold))
                    .foregroundStyle(achievement.rarity.textColor)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(
                        RoundedRectangle(cornerRadius: 4)
                            .fill(achievement.rarity.bgColor)
                    )
            }
            
            // Icon
            Text(achievement.icon)
                .font(.system(size: 36))
            
            // Name
            Text(achievement.name)
                .font(.caption.weight(.bold))
                .foregroundStyle(isUnlocked ? achievement.rarity.textColor : .textPrimary)
            
            // Description
            Text(achievement.desc)
                .font(.system(size: 10))
                .foregroundStyle(.muted)
                .lineLimit(2)
                .multilineTextAlignment(.center)
            
            // Progress
            if !isUnlocked {
                VStack(spacing: 4) {
                    GeometryReader { geo in
                        ZStack(alignment: .leading) {
                            Rectangle()
                                .fill(Color.bg2)
                                .frame(height: 4)
                                .clipShape(Capsule())
                            
                            Rectangle()
                                .fill(Color.brandAmber)
                                .frame(width: geo.size.width * min(Double(progress) / Double(max(max, 1)), 1.0), height: 4)
                                .clipShape(Capsule())
                        }
                    }
                    .frame(height: 4)
                    
                    Text("\(progress)/\(max)")
                        .font(.system(size: 9))
                        .foregroundStyle(.muted)
                }
            } else {
                Text("✅ 已完成")
                    .font(.system(size: 9))
                    .foregroundStyle(.brandAmber)
            }
        }
        .padding(.vertical, Spacing.lg)
        .padding(.horizontal, Spacing.md)
        .background(
            RoundedRectangle(cornerRadius: CornerRadius.small)
                .fill(isUnlocked ? Color.brandAmber.opacity(0.06) : Color.card)
                .overlay(
                    RoundedRectangle(cornerRadius: CornerRadius.small)
                        .stroke(isUnlocked ? Color.brandAmber : Color.border, lineWidth: 1)
                )
        )
        .opacity(isUnlocked ? 1.0 : 0.6)
        .saturation(isUnlocked ? 1.0 : 0.4)
    }
}
