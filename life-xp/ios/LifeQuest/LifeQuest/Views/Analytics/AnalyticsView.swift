import SwiftUI
import Charts

struct AnalyticsView: View {
    @State private var weekOffset = 0
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: Spacing.xl) {
                    // Week Navigation
                    HStack {
                        Button { if weekOffset > 0 { weekOffset -= 1 } } label: {
                            Image(systemName: "chevron.left")
                                .foregroundStyle(weekOffset > 0 ? .textSecondary : .muted.opacity(0.3))
                        }
                        .disabled(weekOffset == 0)
                        Spacer()
                        Text(weekLabel)
                            .font(.subheadline.weight(.bold))
                            .foregroundStyle(.textSecondary)
                        Spacer()
                        Button { weekOffset += 1 } label: {
                            Image(systemName: "chevron.right")
                                .foregroundStyle(.textSecondary)
                        }
                    }
                    .padding(.horizontal, Spacing.md)
                    
                    // Weekly Bar Chart
                    weeklyChartCard
                    
                    // Category Distribution
                    categoryDistributionCard
                    
                    // Heatmap (placeholder)
                    heatmapCard
                    
                    // Summary Stats
                    summaryCard
                }
                .padding(Spacing.lg)
            }
            .background(Color.bg)
            .navigationTitle("数据分析")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    private var weekLabel: String {
        let cal = Calendar.current
        let end = cal.date(byAdding: .day, value: -weekOffset * 7, to: Date())!
        let start = cal.date(byAdding: .day, value: -6, to: end)!
        let fmt = DateFormatter()
        fmt.dateFormat = "M/d"
        return "\(fmt.string(from: start)) - \(fmt.string(from: end))"
    }
    
    private var weeklyChartCard: some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            HStack {
                Circle().fill(Color.brandCyan).frame(width: 6, height: 6)
                Text("每日经验")
                    .font(.caption.weight(.bold))
                    .foregroundStyle(.textSecondary)
            }
            
            // Placeholder - will be replaced with real data from ViewModel
            Chart {
                ForEach(0..<7, id: \.self) { day in
                    BarMark(
                        x: .value("Day", weekdayName(day)),
                        y: .value("XP", 0)
                    )
                    .foregroundStyle(.brand.gradient)
                    .cornerRadius(4)
                }
            }
            .frame(height: 200)
            .chartXAxis {
                AxisMarks(values: .automatic(desiredCount: 7)) { value in
                    AxisValueLabel()
                }
            }
            .chartYAxis {
                AxisMarks { value in
                    AxisGridLine(stroke: StrokeStyle(lineWidth: 0.5))
                        .foregroundStyle(Color.border)
                    AxisValueLabel()
                        .font(.caption2)
                        .foregroundStyle(.muted)
                }
            }
            .overlay(alignment: .center) {
                Text("接入数据后显示")
                    .font(.caption)
                    .foregroundStyle(.muted.opacity(0.6))
            }
        }
        .padding(Spacing.xl)
        .background(
            RoundedRectangle(cornerRadius: CornerRadius.medium)
                .fill(Color.card)
                .overlay(
                    RoundedRectangle(cornerRadius: CornerRadius.medium)
                        .stroke(Color.border, lineWidth: 1)
                )
        )
    }
    
    private var categoryDistributionCard: some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            HStack {
                Circle().fill(Color.brandPink).frame(width: 6, height: 6)
                Text("类别分布")
                    .font(.caption.weight(.bold))
                    .foregroundStyle(.textSecondary)
            }
            
            ForEach(Category.builtIn) { cat in
                HStack {
                    Text(cat.icon)
                    Text(cat.name)
                        .font(.subheadline)
                        .frame(width: 40, alignment: .leading)
                    
                    GeometryReader { geo in
                        Rectangle()
                            .fill(Color(hex: cat.color).opacity(0.8))
                            .frame(width: 0, height: 8)
                            .clipShape(Capsule())
                    }
                    .frame(height: 8)
                    
                    Text("0h")
                        .font(.caption2.monospacedDigit())
                        .foregroundStyle(.muted)
                        .frame(width: 28, alignment: .trailing)
                }
            }
            .overlay(alignment: .center) {
                Text("接入数据后显示")
                    .font(.caption)
                    .foregroundStyle(.muted.opacity(0.6))
                    .padding(.top, 60)
            }
        }
        .padding(Spacing.xl)
        .background(
            RoundedRectangle(cornerRadius: CornerRadius.medium)
                .fill(Color.card)
                .overlay(
                    RoundedRectangle(cornerRadius: CornerRadius.medium)
                        .stroke(Color.border, lineWidth: 1)
                )
        )
    }
    
    private var heatmapCard: some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            HStack {
                Circle().fill(Color.brandGreen).frame(width: 6, height: 6)
                Text("活跃热力图")
                    .font(.caption.weight(.bold))
                    .foregroundStyle(.textSecondary)
            }
            
            // Placeholder
            Text("（热力图将在接入数据后显示）")
                .font(.caption)
                .foregroundStyle(.muted)
                .frame(maxWidth: .infinity, minHeight: 100)
        }
        .padding(Spacing.xl)
        .background(
            RoundedRectangle(cornerRadius: CornerRadius.medium)
                .fill(Color.card)
                .overlay(
                    RoundedRectangle(cornerRadius: CornerRadius.medium)
                        .stroke(Color.border, lineWidth: 1)
                )
        )
    }
    
    private var summaryCard: some View {
        HStack(spacing: Spacing.md) {
            SummaryStatView(title: "本周 XP", value: "—")
            SummaryStatView(title: "本周时长", value: "—")
            SummaryStatView(title: "日均 XP", value: "—")
            SummaryStatView(title: "记录数", value: "—")
        }
    }
    
    private func weekdayName(_ index: Int) -> String {
        let cal = Calendar.current
        let startOfWeek = cal.date(from: cal.dateComponents([.yearForWeekOfYear, .weekOfYear], from: Date()))!
        let date = cal.date(byAdding: .day, value: index, to: startOfWeek)!
        let fmt = DateFormatter()
        fmt.dateFormat = "EEE"
        return fmt.string(from: date)
    }
}

struct SummaryStatView: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack(spacing: Spacing.xs) {
            Text(value)
                .font(.title3.weight(.black).monospacedDigit())
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
