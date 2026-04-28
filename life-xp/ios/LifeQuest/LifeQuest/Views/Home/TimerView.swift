import SwiftUI

struct TimerView: View {
    @State private var selectedCategory: Category = Category.builtIn[0]
    @State private var isRunning = false
    @State private var elapsedSeconds = 0
    @State private var timerTitle = ""
    @State private var showPresetSheet = false
    @State private var showCompletion = false
    
    // Background timer
    @State private var startDate: Date?
    @State private var accumulatedSeconds: Int = 0
    
    // Presets
    let presets = [
        (label: "番茄钟", minutes: 25, icon: "🍅"),
        (label: "短休息", minutes: 5, icon: "☕"),
        (label: "长专注", minutes: 45, icon: "🎯"),
        (label: "深潜模式", minutes: 90, icon: "🧠"),
    ]
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                Spacer()
                
                // Timer Ring
                VStack(spacing: Spacing.xl) {
                    // Timer Display with Ring
                    ZStack {
                        // Background ring
                        Circle()
                            .stroke(Color.bg2, lineWidth: 6)
                            .frame(width: 260, height: 260)
                        
                        // Progress ring
                        Circle()
                            .trim(from: 0, to: isRunning ? timerProgress : 0)
                            .stroke(
                                LinearGradient(
                                    colors: [Color(hex: selectedCategory.color), Color(hex: selectedCategory.color).opacity(0.5)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                style: StrokeStyle(lineWidth: 6, lineCap: .round)
                            )
                            .frame(width: 260, height: 260)
                            .rotationEffect(.degrees(-90))
                            .animation(.linear(duration: 0.5), value: elapsedSeconds)
                        
                        // Time & XP
                        VStack(spacing: 8) {
                            Text(timeString)
                                .font(.system(size: 56, weight: .thin, design: .rounded).monospacedDigit())
                                .foregroundStyle(isRunning ? .textPrimary : .textSecondary)
                                .contentTransition(.numericText())
                            
                            if isRunning {
                                Text("+\(currentXP) XP")
                                    .font(.subheadline.weight(.bold).monospacedDigit())
                                    .foregroundStyle(.brandEmerald)
                            }
                            
                            if isRunning || elapsedSeconds > 0 {
                                Text(selectedCategory.icon + " " + selectedCategory.name)
                                    .font(.caption.weight(.medium))
                                    .foregroundStyle(Color(hex: selectedCategory.color))
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 4)
                                    .background(
                                        Capsule().fill(Color(hex: selectedCategory.color).opacity(0.1))
                                    )
                            }
                        }
                    }
                }
                .padding(.bottom, Spacing.xxxl)
                
                // Title Input
                TextField("做了什么？", text: $timerTitle)
                    .textFieldStyle(.plain)
                    .padding(Spacing.md)
                    .padding(.horizontal, Spacing.lg)
                    .background(Color.card)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.border)
                    )
                    .padding(.horizontal, Spacing.xxl)
                
                // Category Selector (compact)
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: Spacing.sm) {
                        ForEach(Category.builtIn) { cat in
                            Button {
                                withAnimation(.spring(response: 0.2)) {
                                    selectedCategory = cat
                                }
                            } label: {
                                HStack(spacing: 4) {
                                    Text(cat.icon)
                                    Text(cat.name)
                                        .font(.caption.weight(.semibold))
                                }
                                .padding(.horizontal, Spacing.md)
                                .padding(.vertical, 8)
                                .background(
                                    RoundedRectangle(cornerRadius: 20)
                                        .fill(selectedCategory.id == cat.id ? Color(hex: cat.color).opacity(0.15) : Color.card)
                                )
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(selectedCategory.id == cat.id ? Color(hex: cat.color) : Color.border, lineWidth: 1)
                                )
                                .foregroundStyle(selectedCategory.id == cat.id ? Color(hex: cat.color) : .textSecondary)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.horizontal, Spacing.xxl)
                }
                .padding(.vertical, Spacing.lg)
                
                // Presets
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: Spacing.sm) {
                        ForEach(presets, id: \.minutes) { preset in
                            Button {
                                guard !isRunning else { return }
                                elapsedSeconds = preset.minutes * 60
                                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                            } label: {
                                HStack(spacing: 4) {
                                    Text(preset.icon)
                                    Text(preset.label)
                                        .font(.caption2.weight(.semibold))
                                    Text("\(preset.minutes)min")
                                        .font(.caption2.weight(.bold).monospacedDigit())
                                }
                                .padding(.horizontal, 10)
                                .padding(.vertical, 6)
                                .background(
                                    Capsule().fill(Color.bg2)
                                )
                                .foregroundStyle(.textSecondary)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.horizontal, Spacing.xxl)
                }
                
                // Controls
                HStack(spacing: Spacing.xxl) {
                    // Reset
                    Button {
                        resetTimer()
                    } label: {
                        Image(systemName: "arrow.counterclockwise")
                            .font(.title3)
                            .foregroundStyle(.textSecondary)
                            .frame(width: 52, height: 52)
                            .background(Circle().fill(Color.card))
                    }
                    
                    // Start/Pause
                    Button {
                        toggleTimer()
                    } label: {
                        ZStack {
                            Circle()
                                .fill(isRunning ? Color.brandGreen : Color.brandPurple)
                                .frame(width: 76, height: 76)
                                .shadow(color: isRunning ? Color.brandGreen.opacity(0.3) : Color.brandPurple.opacity(0.3), radius: 12, y: 6)
                            
                            Image(systemName: isRunning ? "pause.fill" : "play.fill")
                                .font(.title)
                                .foregroundStyle(.white)
                                .offset(x: isRunning ? 0 : 2)
                        }
                    }
                    
                    // Submit
                    Button {
                        submitTimer()
                    } label: {
                        Image(systemName: "checkmark")
                            .font(.title3.weight(.semibold))
                            .foregroundStyle(elapsedSeconds > 0 ? .white : .muted)
                            .frame(width: 52, height: 52)
                            .background(Circle().fill(elapsedSeconds > 0 ? Color.brandEmerald : Color.bg2))
                    }
                    .disabled(elapsedSeconds == 0)
                }
                .padding(.top, Spacing.xl)
                
                Spacer()
            }
            .background(Color.bg)
            .navigationTitle("专注计时")
            .navigationBarTitleDisplayMode(.inline)
            .fullScreenCover(isPresented: $showCompletion) {
                TimerCompletionView(
                    category: selectedCategory,
                    duration: elapsedSeconds / 60,
                    xp: currentXP,
                    title: timerTitle.isEmpty ? selectedCategory.name : timerTitle
                ) {
                    showCompletion = false
                }
            }
        }
    }
    
    // MARK: - Computed
    
    private var currentMinutes: Int { elapsedSeconds / 60 }
    private var currentXP: Int { currentMinutes * selectedCategory.xpPerMin }
    
    private var timerProgress: Double {
        // Continuous animation based on seconds within a minute
        Double(elapsedSeconds % 60) / 60.0
    }
    
    private var timeString: String {
        let hours = elapsedSeconds / 3600
        let minutes = (elapsedSeconds % 3600) / 60
        let seconds = elapsedSeconds % 60
        if hours > 0 {
            return String(format: "%d:%02d:%02d", hours, minutes, seconds)
        }
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    // MARK: - Timer Logic (background-safe)
    
    private func toggleTimer() {
        if isRunning {
            // Pause
            accumulatedSeconds += Int(Date().timeIntervalSince(startDate ?? Date()))
            startDate = nil
            isRunning = false
        } else {
            // Start
            startDate = Date()
            isRunning = true
        }
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
    }
    
    private func resetTimer() {
        accumulatedSeconds = 0
        startDate = nil
        isRunning = false
        elapsedSeconds = 0
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
    }
    
    private func submitTimer() {
        let minutes = elapsedSeconds / 60
        guard minutes > 0 else { return }
        let xp = minutes * selectedCategory.xpPerMin
        
        // TODO: Submit to Supabase
        print("⏱️ Timer: \(selectedCategory.name) - \(timerTitle) - \(minutes)min - +\(xp)XP")
        
        // Reset state
        let finalDuration = minutes
        let finalXP = xp
        let finalTitle = timerTitle.isEmpty ? selectedCategory.name : timerTitle
        accumulatedSeconds = 0
        startDate = nil
        isRunning = false
        elapsedSeconds = 0
        
        // Show completion celebration
        showCompletion = true
        UINotificationFeedbackGenerator().notificationOccurred(.success)
    }
    
    // Tick every second when running
    private func updateElapsed() {
        guard isRunning, let start = startDate else { return }
        elapsedSeconds = accumulatedSeconds + Int(Date().timeIntervalSince(start))
    }
}

// MARK: - Timer Completion View

struct TimerCompletionView: View {
    let category: Category
    let duration: Int
    let xp: Int
    let title: String
    let onDismiss: () -> Void
    
    @State private var showXP = false
    @State private var showButton = false
    
    var body: some View {
        ZStack {
            Color.bg.ignoresSafeArea()
            
            VStack(spacing: Spacing.xxl) {
                Spacer()
                
                Text(category.icon)
                    .font(.system(size: 72))
                    .scaleEffect(showXP ? 1.0 : 0.5)
                
                Text("专注完成！")
                    .font(.system(size: 28, weight: .black, design: .rounded))
                
                VStack(spacing: Spacing.md) {
                    Text(title)
                        .font(.title3.weight(.semibold))
                        .foregroundStyle(Color(hex: category.color))
                    
                    HStack(spacing: Spacing.xl) {
                        VStack(spacing: 4) {
                            Text(formatDuration(duration))
                                .font(.title.weight(.black).monospacedDigit())
                            Text("时长")
                                .font(.caption)
                                .foregroundStyle(.muted)
                        }
                        
                        Rectangle()
                            .fill(Color.border)
                            .frame(width: 1, height: 40)
                        
                        VStack(spacing: 4) {
                            Text("+\(xp)")
                                .font(.title.weight(.black).monospacedDigit())
                                .foregroundStyle(.brandEmerald)
                            Text("经验值")
                                .font(.caption)
                                .foregroundStyle(.muted)
                        }
                    }
                    .padding(Spacing.xl)
                    .background(
                        RoundedRectangle(cornerRadius: CornerRadius.medium)
                            .fill(Color.card)
                    )
                }
                .opacity(showXP ? 1 : 0)
                
                Spacer()
                
                Button {
                    onDismiss()
                } label: {
                    Text("太棒了！")
                        .font(.headline)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 54)
                        .background(
                            RoundedRectangle(cornerRadius: CornerRadius.small)
                                .fill(.brand.gradient)
                        )
                }
                .padding(.horizontal, Spacing.xxl)
                .padding(.bottom, Spacing.xxxl)
                .opacity(showButton ? 1 : 0)
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.5).delay(0.2)) {
                showXP = true
            }
            withAnimation(.spring(response: 0.4).delay(0.6)) {
                showButton = true
            }
            UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
        }
    }
    
    private func formatDuration(_ minutes: Int) -> String {
        if minutes >= 60 {
            let h = minutes / 60
            let m = minutes % 60
            return m > 0 ? "\(h)h\(m)min" : "\(h)h"
        }
        return "\(minutes)min"
    }
}
