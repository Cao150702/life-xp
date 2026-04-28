import SwiftUI

struct QuickLogView: View {
    @State private var selectedCategory: Category?
    @State private var title = ""
    @State private var duration = ""
    @State private var note = ""
    @FocusState private var focusedField: Field?
    
    enum Field { case title, duration, note }
    
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
                    
                    // Duration
                    VStack(alignment: .leading, spacing: Spacing.sm) {
                        Text("时长（分钟）")
                            .font(.caption.weight(.bold))
                            .foregroundStyle(.muted)
                        
                        TextField("例：90", text: $duration)
                            .focused($focusedField, equals: .duration)
                            .textFieldStyle(.plain)
                            .keyboardType(.numberPad)
                            .padding(Spacing.lg)
                            .background(Color.card)
                            .clipShape(RoundedRectangle(cornerRadius: CornerRadius.small))
                            .overlay(
                                RoundedRectangle(cornerRadius: CornerRadius.small)
                                    .stroke(focusedField == .duration ? Color.brandPurple : Color.border)
                            )
                    }
                    
                    // Note
                    VStack(alignment: .leading, spacing: Spacing.sm) {
                        Text("备注（可选）")
                            .font(.caption.weight(.bold))
                            .foregroundStyle(.muted)
                        
                        TextField("例：第三章 重点", text: $note)
                            .focused($focusedField, equals: .note)
                            .textFieldStyle(.plain)
                            .padding(Spacing.lg)
                            .background(Color.card)
                            .clipShape(RoundedRectangle(cornerRadius: CornerRadius.small))
                            .overlay(
                                RoundedRectangle(cornerRadius: CornerRadius.small)
                                    .stroke(focusedField == .note ? Color.brandPurple : Color.border)
                            )
                    }
                    
                    // XP Preview
                    if let cat = selectedCategory, let dur = Int(duration), dur > 0 {
                        HStack {
                            Text("⚡")
                            Text("预计 +\(dur * cat.xpPerMin) XP")
                                .font(.subheadline.weight(.bold))
                                .foregroundStyle(.brandEmerald)
                        }
                        .padding(Spacing.md)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(
                            RoundedRectangle(cornerRadius: CornerRadius.small)
                                .fill(Color.brandEmerald.opacity(0.1))
                        )
                    }
                    
                    // Submit Button
                    Button {
                        submitLog()
                    } label: {
                        Text("提交记录")
                            .font(.headline)
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 54)
                            .background(
                                RoundedRectangle(cornerRadius: CornerRadius.small)
                                    .fill(canSubmit ? .brand : .gray.opacity(0.3))
                            )
                    }
                    .disabled(!canSubmit)
                }
                .padding(Spacing.lg)
            }
            .background(Color.bg)
            .navigationTitle("快速记录")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    private var canSubmit: Bool {
        selectedCategory != nil && !title.trimmingCharacters(in: .whitespaces).isEmpty && (Int(duration) ?? 0) > 0
    }
    
    private func submitLog() {
        // TODO: Submit to ViewModel & Supabase
        UINotificationFeedbackGenerator().notificationOccurred(.success)
        
        // Reset
        selectedCategory = nil
        title = ""
        duration = ""
        note = ""
    }
}
