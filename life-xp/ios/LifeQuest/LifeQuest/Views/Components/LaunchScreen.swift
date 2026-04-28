import SwiftUI

struct LaunchScreen: View {
    var body: some View {
        ZStack {
            Color("bg")
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                Text("⚔️")
                    .font(.system(size: 72))
                
                Text("LifeQuest")
                    .font(.system(size: 32, weight: .black, design: .rounded))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [Color("purple"), Color("blue")],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                
                ProgressView()
                    .tint(Color("purple2"))
            }
        }
    }
}
