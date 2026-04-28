import SwiftUI

struct TimerView: View {
    @State private var selectedCategory: Category = Category.builtIn[0]
    @State private var isRunning = false
    @State private var elapsedSeconds = 0
    @State private var timerTitle = ""
    @State private var timer: Timer?
    
    var body: some View {
        NavigationStack {
            VStack(spacing: Spacing.xxxl) {
                Spacer()
                
                // Timer Display
                VStack(spacing: Spacing.lg) {
                    Text(timeString)
                        .font(.system(size: 64, weight: .thin, design: .rounded).monospacedDigit())
                        .foregroundStyle(isRunning ? .brand : .textPrimary)
                        .contentTransition(.numericText())
                    
                    if isRunning {
                        Text(selectedCategory.icon + " " + selectedCategory.name)
                            .font(.subheadline.weight(.medium))
                            .foregroundStyle(Color(hex: selectedCategory.color))
                    }
                }
                .padding(Spacing.xxxl)
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: CornerRadius.large)
                        .fill(Color.card)
                        .overlay(
                            RoundedRectangle(cornerRadius: CornerRadius.large)
                                .stroke(Color.border, lineWidth: 1)
                        )
                )
                .padding(.horizontal, Spacing.xxl)
                
                // Title Input
                TextField("做了什么？", text: $timerTitle)
                    .textFieldStyle(.plain)
                    .padding(Spacing.lg)
                    .background(Color.card)
                    .clipShape(RoundedRectangle(cornerRadius: CornerRadius.small))
                    .overlay(
                        RoundedRectangle(cornerRadius: CornerRadius.small)
                            .stroke(Color.border)
                    )
                    .padding(.horizontal, Spacing.xxl)
                
                // Category Selector
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: Spacing.sm) {
                        ForEach(Category.builtIn) { cat in
                            Button {
                                withAnimation(.spring(response: 0.2)) {
                                    selectedCategory = cat
                                }
                            } label: {
                                HStack(spacing: 6) {
                                    Text(cat.icon)
                                    Text(cat.name)
                                        .font(.subheadline.weight(.semibold))
                                }
                                .padding(.horizontal, Spacing.lg)
                                .padding(.vertical, Spacing.md)
                                .background(
                                    RoundedRectangle(cornerRadius: CornerRadius.small)
                                        .fill(selectedCategory.id == cat.id ? Color(hex: cat.color).opacity(0.2) : Color.card)
                                )
                                .overlay(
                                    RoundedRectangle(cornerRadius: CornerRadius.small)
                                        .stroke(selectedCategory.id == cat.id ? Color(hex: cat.color) : Color.border, lineWidth: 1.5)
                                )
                                .foregroundStyle(selectedCategory.id == cat.id ? Color(hex: cat.color) : .textSecondary)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.horizontal, Spacing.xxl)
                }
                
                // Controls
                HStack(spacing: Spacing.xl) {
                    // Reset
                    Button {
                        resetTimer()
                    } label: {
                        Image(systemName: "arrow.counterclockwise")
                            .font(.title2)
                            .foregroundStyle(.textSecondary)
                            .frame(width: 56, height: 56)
                            .background(
                                Circle().fill(Color.card)
                            )
                    }
                    
                    // Start/Pause
                    Button {
                        toggleTimer()
                    } label: {
                        Image(systemName: isRunning ? "pause.fill" : "play.fill")
                            .font(.title)
                            .foregroundStyle(.white)
                            .frame(width: 80, height: 80)
                            .background(
                                Circle()
                                    .fill(isRunning ? .success : .brand)
                                    .shadow(color: isRunning ? Color.brandGreen.opacity(0.4) : Color.brandPurple.opacity(0.4), radius: 12, y: 6)
                            )
                    }
                    
                    // Submit
                    Button {
                        submitTimer()
                    } label: {
                        Image(systemName: "checkmark")
                            .font(.title2)
                            .foregroundStyle(.white)
                            .frame(width: 56, height: 56)
                            .background(
                                Circle().fill(.brand)
                            )
                    }
                    .disabled(!isRunning && elapsedSeconds == 0)
                    .opacity(!isRunning && elapsedSeconds == 0 ? 0.5 : 1.0)
                }
                .padding(.top, Spacing.lg)
                
                Spacer()
            }
            .background(Color.bg)
            .navigationTitle("专注计时")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    // MARK: - Timer Logic
    
    private var timeString: String {
        let hours = elapsedSeconds / 3600
        let minutes = (elapsedSeconds % 3600) / 60
        let seconds = elapsedSeconds % 60
        if hours > 0 {
            return String(format: "%d:%02d:%02d", hours, minutes, seconds)
        }
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    private func toggleTimer() {
        if isRunning {
            timer?.invalidate()
            timer = nil
            isRunning = false
        } else {
            isRunning = true
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                Task { @MainActor in
                    elapsedSeconds += 1
                }
            }
        }
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
    }
    
    private func resetTimer() {
        timer?.invalidate()
        timer = nil
        isRunning = false
        elapsedSeconds = 0
    }
    
    private func submitTimer() {
        // TODO: Submit to ViewModel & Supabase
        let minutes = elapsedSeconds / 60
        guard minutes > 0 else { return }
        
        resetTimer()
        // Show success feedback
        UINotificationFeedbackGenerator().notificationOccurred(.success)
    }
}
