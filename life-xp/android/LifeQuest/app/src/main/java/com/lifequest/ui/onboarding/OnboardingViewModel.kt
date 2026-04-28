package com.lifequest.ui.onboarding

import androidx.lifecycle.ViewModel
import dagger.hilt.android.lifecycle.HiltViewModel
import javax.inject.Inject

@HiltViewModel
class OnboardingViewModel @Inject constructor(
    // TODO: AuthRepository
) : ViewModel() {
    var name: String = ""
    var avatar: String = "🧑‍💻"

    fun completeOnboarding(onComplete: () -> Unit) {
        // TODO: save to Supabase profile
        onComplete()
    }
}
