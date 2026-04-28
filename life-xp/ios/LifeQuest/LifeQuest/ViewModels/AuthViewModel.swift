import SwiftUI
import SwiftData
import Supabase

@MainActor
class AuthViewModel: ObservableObject {
    @Published var isLoading = true
    @Published var needsOnboarding = false
    @Published var isAuthenticated = false
    @Published var userName = ""
    @Published var userAvatar = "🧑‍💻"
    
    private let supabase = SupabaseManager.shared.client
    
    init() {
        Task { await checkSession() }
    }
    
    func checkSession() async {
        do {
            let session = try await supabase.auth.session
            isAuthenticated = true
            
            // Fetch profile
            let profile: ProfileResponse = try await supabase
                .from("profiles")
                .select()
                .eq("id", value: session.user.id)
                .single()
                .execute()
                .value
            
            userName = profile.name
            userAvatar = profile.avatar
            needsOnboarding = profile.name.isEmpty
        } catch {
            // No session - try anonymous login
            await anonymousLogin()
        }
        isLoading = false
    }
    
    func anonymousLogin() async {
        do {
            _ = try await supabase.auth.signInAnonymously()
            isAuthenticated = true
            needsOnboarding = true
        } catch {
            print("Anonymous login failed: \(error)")
        }
    }
    
    func completeOnboarding(name: String, avatar: String) async {
        userName = name
        userAvatar = avatar
        needsOnboarding = false
        
        let userId = try? await supabase.auth.session.user.id
        guard let userId else { return }
        
        try? await supabase
            .from("profiles")
            .update(["name": name, "avatar": avatar])
            .eq("id", value: userId)
            .execute()
    }
    
    func signUpWithEmail(_ email: String) async throws {
        try await supabase.auth.linkAnonymousWithOtp(email: email)
    }
    
    func signUpWithPhone(_ phone: String) async throws {
        try await supabase.auth.linkAnonymousWithPhone(phone: phone)
    }
    
    func signOut() async {
        try? await supabase.auth.signOut()
        isAuthenticated = false
        needsOnboarding = false
    }
}

// MARK: - Profile Response (Supabase)

struct ProfileResponse: Codable {
    let id: String
    let name: String
    let avatar: String
    let totalXp: Int
    let maxStreak: Int
    let createdAt: String
    
    enum CodingKeys: String, CodingKey {
        case id, name, avatar, createdAt
        case totalXp = "total_xp"
        case maxStreak = "max_streak"
    }
}
