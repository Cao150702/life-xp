import Foundation
import Supabase

enum SupabaseManager {
    static let shared = Client(
        supabaseURL: URL(string: Secrets.supabaseURL)!,
        supabaseKey: Secrets.supabaseAnonKey
    )
}

// MARK: - Secrets
enum Secrets {
    static let supabaseURL = "https://wnsovtrfzgjgrsuwnkte.supabase.co"
    static let supabaseAnonKey = "sb_publishable_wmD46P2xe2E4RsFshIuksw_-VGtymEH"
}
