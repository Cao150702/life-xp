import SwiftUI

struct LaunchScreen: View {
    @State private var isAnimating = false
    @State private var showSubtitle = false
    
    var body: some View {
        ZStack {
            Color.bg.ignoresSafeArea()
            
            // Subtle gradient background
            Circle()
                .fill(Color.brandPurple.opacity(0.06))
                .frame(width: 300, height: 300)
                .blur(radius: 80)
                .offset(y: -50)
            
            Circle()
                .fill(Color.brandBlue.opacity(0.04))
                .frame(width: 250, height: 250)
                .blur(radius: 60)
                .offset(y: 60)
            
            VStack(spacing: Spacing.xl) {
                // Logo
                Text("⚔️")
                    .font(.system(size: 72))
                    .scaleEffect(isAnimating ? 1.0 : 0.3)
                    .opacity(isAnimating ? 1 : 0)
                
                // App name
                Text("LifeQuest")
                    .font(.system(size: 34, weight: .black, design: .rounded))
                    .foregroundStyle(.brand.gradient)
                    .offset(y: isAnimating ? 0 : 20)
                    .opacity(isAnimating ? 1 : 0)
                
                // Subtitle
                Text("把每一次努力变成看得见的成长")
                    .font(.subheadline)
                    .foregroundStyle(.textSecondary)
                    .opacity(showSubtitle ? 1 : 0)
                    .offset(y: showSubtitle ? 0 : 10)
                
                // Loading
                ProgressView()
                    .tint(.brandPurple)
                    .opacity(showSubtitle ? 1 : 0)
                    .padding(.top, Spacing.md)
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
                isAnimating = true
            }
            withAnimation(.easeOut(duration: 0.5).delay(0.3)) {
                showSubtitle = true
            }
        }
    }
}
