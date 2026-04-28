import Foundation
import Supabase

// MARK: - Secrets
enum Secrets {
    static let supabaseURL = "https://wnsovtrfzgjgrsuwnkte.supabase.co"
    static let supabaseAnonKey = "sb_publishable_wmD46P2xe2E4RsFshIuksw_-VGtymEH"
}

// MARK: - Supabase Manager
final class SupabaseManager {
    static let shared = SupabaseManager()

    let client: SupabaseClient

    private init() {
        client = SupabaseClient(
            supabaseURL: URL(string: Secrets.supabaseURL)!,
            supabaseKey: Secrets.supabaseAnonKey
        )
    }
}
