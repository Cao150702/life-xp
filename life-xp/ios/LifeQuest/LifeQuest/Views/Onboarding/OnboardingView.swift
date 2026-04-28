import SwiftUI

struct OnboardingView: View {
    @EnvironmentObject var authVM: AuthViewModel
    @State private var step = 0
    @State private var userName = ""
    @State private var selectedAvatar = "🧑‍💻"
    
    var body: some View {
        ZStack {
            Color.bg.ignoresSafeArea()
            
            VStack(spacing: 0) {
                Spacer()
                
                // Step content
                Group {
                    switch step {
                    case 0:
                        welcomeStep
                    case 1:
                        nameStep
                    case 2:
                        avatarStep
                    default:
                        EmptyView()
                    }
                }
                .transition(.asymmetric(
                    insertion: .move(edge: .trailing).combined(with: .opacity),
                    removal: .move(edge: .leading).combined(with: .opacity)
                ))
                
                Spacer()
                
                // Next button
                nextButton
                    .padding(.horizontal, Spacing.xxl)
                    .padding(.bottom, Spacing.xxxl)
            }
        }
        .animation(.easeInOut(duration: 0.35), value: step)
    }
    
    // MARK: - Welcome
    private var welcomeStep: some View {
        VStack(spacing: Spacing.xl) {
            Text("⚔️")
                .font(.system(size: 80))
            
            Text("LifeQuest")
                .font(.system(size: 36, weight: .black, design: .rounded))
                .foregroundStyle(.brand)
            
            Text("把每一次努力变成看得见的成长")
                .font(.body)
                .foregroundStyle(.textSecondary)
                .multilineTextAlignment(.center)
        }
    }
    
    // MARK: - Name
    private var nameStep: some View {
        VStack(spacing: Spacing.xl) {
            Text("你叫什么名字？")
                .font(.title2.weight(.bold))
            
            TextField("输入你的名字", text: $userName)
                .textFieldStyle(.plain)
                .padding(Spacing.lg)
                .background(Color.card)
                .clipShape(RoundedRectangle(cornerRadius: CornerRadius.small))
                .overlay(
                    RoundedRectangle(cornerRadius: CornerRadius.small)
                        .stroke(Color.border)
                )
                .padding(.horizontal, Spacing.xl)
        }
    }
    
    // MARK: - Avatar
    private var avatarStep: some View {
        VStack(spacing: Spacing.xl) {
            Text("选择你的角色")
                .font(.title2.weight(.bold))
            
            Text(selectedAvatar)
                .font(.system(size: 80))
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 4), spacing: Spacing.md) {
                ForEach(Category.avatars, id: \.self) { avatar in
                    Button {
                        withAnimation(.spring(response: 0.3)) {
                            selectedAvatar = avatar
                        }
                    } label: {
                        Text(avatar)
                            .font(.system(size: 32))
                            .frame(width: 64, height: 64)
                            .background(
                                RoundedRectangle(cornerRadius: .infinity)
                                    .fill(selectedAvatar == avatar ? Color.brandPurple.opacity(0.2) : Color.card)
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: .infinity)
                                    .stroke(selectedAvatar == avatar ? Color.brandPurple : Color.border, lineWidth: 2)
                            )
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, Spacing.xxl)
        }
    }
    
    // MARK: - Next Button
    private var nextButton: some View {
        Button {
            withAnimation {
                if step < 2 {
                    step += 1
                } else {
                    Task {
                        await authVM.completeOnboarding(name: userName, avatar: selectedAvatar)
                    }
                }
            }
        } label: {
            Text(step == 2 ? "开始冒险 →" : "下一步")
                .font(.headline)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 54)
                .background(
                    RoundedRectangle(cornerRadius: CornerRadius.small)
                        .fill(.brand)
                        .shadow(color: .brandPurple.opacity(0.3), radius: 8, y: 4)
                )
        }
        .disabled(step == 1 && userName.trimmingCharacters(in: .whitespaces).isEmpty)
        .opacity(step == 1 && userName.trimmingCharacters(in: .whitespaces).isEmpty ? 0.5 : 1.0)
    }
}
