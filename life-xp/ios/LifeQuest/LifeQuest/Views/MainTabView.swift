import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 0
    @State private var showRecordSheet = false
    @State private var recordMode: RecordMode = .timer
    @EnvironmentObject var authVM: AuthViewModel
    
    enum RecordMode {
        case timer, quickLog
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $selectedTab) {
                HomeView(onRecordTap: { recordMode = .quickLog; showRecordSheet = true })
                    .tabItem {
                        Label("首页", systemImage: "house.fill")
                    }
                    .tag(0)
                
                TimerView()
                    .tabItem {
                        Label("专注", systemImage: "timer")
                    }
                    .tag(1)
                
                AnalyticsView()
                    .tabItem {
                        Label("分析", systemImage: "chart.bar.fill")
                    }
                    .tag(2)
                
                AchievementsView()
                    .tabItem {
                        Label("成就", systemImage: "trophy.fill")
                    }
                    .tag(3)
            }
            .tint(.brandPurple)
            
            // Floating Record Button (center of tab bar)
            FloatingRecordButton {
                showRecordSheet = true
            }
            .offset(y: -20)
            .sheet(isPresented: $showRecordSheet) {
                QuickLogView()
                    .environmentObject(authVM)
                    .presentationDetents([.medium, .large])
                    .presentationDragIndicator(.visible)
            }
        }
    }
}

// MARK: - Floating Record Button

struct FloatingRecordButton: View {
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            ZStack {
                Circle()
                    .fill(.brand.gradient)
                    .frame(width: 56, height: 56)
                    .shadow(color: .brandPurple.opacity(0.4), radius: 8, y: 4)
                
                Image(systemName: "plus")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundStyle(.white)
            }
        }
        .buttonStyle(.plain)
    }
}
