import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tabItem {
                    Label("首页", systemImage: "house.fill")
                }
                .tag(0)
            
            TimerView()
                .tabItem {
                    Label("专注", systemImage: "timer")
                }
                .tag(1)
            
            QuickLogView()
                .tabItem {
                    Label("记录", systemImage: "plus.circle.fill")
                }
                .tag(2)
            
            AnalyticsView()
                .tabItem {
                    Label("分析", systemImage: "chart.bar.fill")
                }
                .tag(3)
            
            AchievementsView()
                .tabItem {
                    Label("成就", systemImage: "trophy.fill")
                }
                .tag(4)
        }
        .tint(Color("purple"))
    }
}
