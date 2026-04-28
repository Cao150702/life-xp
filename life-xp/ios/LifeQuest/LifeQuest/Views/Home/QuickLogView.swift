import SwiftUI

struct QuickLogView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var selectedCategory: Category?
    @State private var title = ""
    @State private var selectedMinutes = 30
    @State private var note = ""
    @FocusState private var focusedField: Field?
    
    enum Field { case title, note }
    
    private let minuteOptions = Array(stride(from: 5, through: 180, by: 5))
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: Spacing.xl) {
                    // Category Selector
                    VStack(alignment: .leading, spacing: Spacing.md) {
                        Text("选择类别")
                            .font(.caption.weight(.bold))
                            .foregroundStyle(.muted)
                        
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: Spacing.md) {
                            ForEach(Category.builtIn) { cat in
                                Button {
                                    withAnimation(.spring(response: 0.2)) {
                                        selectedCategory = cat
                                    }
                                } label: {
                                    VStack(spacing: 6) {
                                        Text(cat.icon)
                                            .font(.system(size: 28))
                                        Text(cat.name)
                                            .font(.caption.weight(.semibold))
                                    }
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, Spacing.lg)
                                    .background(
                                        RoundedRectangle(cornerRadius: CornerRadius.small)
                                            .fill(selectedCategory?.id == cat.id ? Color(hex: cat.color).opacity(0.15) : Color.card)
                                    )
                                    .overlay(
                                        RoundedRectangle(cornerRadius: CornerRadius.small)
                                            .stroke(selectedCategory?.id == cat.id ? Color(hex: cat.color) : Color.border, lineWidth: selectedCategory?.id == cat.id ? 2 : 1)
                                    )
                                    .foregroundStyle(selectedCategory?.id == cat.id ? Color(hex: cat.color) : .textSecondary)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                    
                    // Title
                    VStack(alignment: .leading, spacing: Spacing.sm) {
                        Text("做了什么")
                            .font(.caption.weight(.bold))
                            .foregroundStyle(.muted)
                        
                        TextField("例：线性代数复习", text: $title)
                            .focused($focusedField, equals: .title)
                            .textFieldStyle(.plain)
                            .padding(Spacing.lg)
                            .background(Color.card)
                            .clipShape(RoundedRectangle(cornerRadius: CornerRadius.small))
                            .overlay(
                                RoundedRectangle(cornerRadius: CornerRadius.small)
                                    .stroke(focusedField == .title ? Color.brandPurple : Color.border)
                            )
                    }
                    
                    // Duration Picker
                    VStack(alignment: .leading, spacing: Spacing.sm) {
                        HStack {
                            Text("时长")
                                .font(.caption.weight(.bold))
                                .foregroundStyle(.muted)
                            Spacer()
                            Text(formatDuration(selectedMinutes))
                                .font(.title3.weight(.bold).monospacedDigit())
                                .foregroundStyle(.brand)
                        }
                        
                        Picker("分钟", selection: $selectedMinutes) {
                            ForEach(minuteOptions, id: \.self) { min in
                                Text(formatDuration(min)).tag(min)
                            }
                        }
                        .pickerStyle(.wheel)
                        .frame(height: 120)
                        .clipped()
                    }
                    .padding(.vertical, 8)
                    .background(Color.card)
                    .clipShape(RoundedRectangle(cornerRadius: CornerRadius.small))
                    
                    // Note (optional, collapsed)
                    DisclosureGroup {
                        TextField("例：第三章 重点", text: $note)
                            .focused($focusedField, equals: .note)
                            .textFieldStyle(.plain)
                            .padding(Spacing.lg)
                            .background(Color.bg2)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                    } label: {
                        Text("备注（可选）")
                            .font(.caption.weight(.bold))
                            .foregroundStyle(.muted)
                    }
                    .tint(.brandPurple)
                    
                    // XP Preview
                    if let cat = selectedCategory {
                        HStack {
                            Image(systemName: "bolt.fill")
                                .foregroundStyle(.brandAmber)
                            Text("预计 +\(selectedMinutes * cat.xpPerMin) XP")
                                .font(.subheadline.weight(.bold))
                                .foregroundStyle(.brandEmerald)
                            Spacer()
                            Text("\(selectedMinutes) × \(cat.xpPerMin)/min")
                                .font(.caption)
                                .foregroundStyle(.muted)
                        }
                        .padding(Spacing.md)
                        .background(
                            RoundedRectangle(cornerRadius: CornerRadius.small)
                                .fill(Color.brandEmerald.opacity(0.08))
                                .overlay(
                                    RoundedRectangle(cornerRadius: CornerRadius.small)
                                        .stroke(Color.brandEmerald.opacity(0.2), lineWidth: 1)
                                )
                        )
                    }
                    
                    // Submit Button
                    Button {
                        submitLog()
                    } label: {
                        HStack(spacing: 8) {
                            Image(systemName: "checkmark.circle.fill")
                            Text("提交记录")
                                .font(.headline)
                        }
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 54)
                        .background(
                            RoundedRectangle(cornerRadius: CornerRadius.small)
                                .fill(canSubmit ? .brand.gradient : Color.gray.opacity(0.3))
                        )
                    }
                    .disabled(!canSubmit)
                }
                .padding(Spacing.lg)
            }
            .background(Color.bg)
            .navigationTitle("快速记录")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("取消") { dismiss() }
                        .foregroundStyle(.textSecondary)
                }
            }
        }
    }
    
    private var canSubmit: Bool {
        selectedCategory != nil && !title.trimmingCharacters(in: .whitespaces).isEmpty
    }
    
    private func formatDuration(_ minutes: Int) -> String {
        if minutes >= 60 {
            let h = minutes / 60
            let m = minutes % 60
            return m > 0 ? "\(h)h\(m)min" : "\(h)h"
        }
        return "\(minutes)min"
    }
    
    private func submitLog() {
        guard let cat = selectedCategory else { return }
        let xp = selectedMinutes * cat.xpPerMin
        
        // TODO: Submit to Supabase
        print("📝 Log: \(cat.name) - \(title) - \(selectedMinutes)min - +\(xp)XP")
        
        UINotificationFeedbackGenerator().notificationOccurred(.success)
        dismiss()
    }
}
