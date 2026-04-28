// LifeQuest.swift
// LifeQuest
//
// App Entry Point - SwiftUI App with Supabase Auth
//

import SwiftUI

@main
struct LifeQuestApp: App {
    @StateObject private var authVM = AuthViewModel()
    
    var body: some Scene {
        WindowGroup {
            Group {
                if authVM.isLoading {
                    LaunchScreen()
                } else if authVM.needsOnboarding {
                    OnboardingView()
                        .environmentObject(authVM)
                } else {
                    MainTabView()
                        .environmentObject(authVM)
                }
            }
            .animation(.easeInOut(duration: 0.3), value: authVM.needsOnboarding)
            .preferredColorScheme(.dark)
        }
    }
}
