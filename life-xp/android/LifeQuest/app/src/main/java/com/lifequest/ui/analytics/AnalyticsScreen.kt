package com.lifequest.ui.analytics

import androidx.compose.foundation.layout.*
import androidx.compose.material3.*
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import com.lifequest.ui.theme.*

@Composable
fun AnalyticsScreen() {
    Column(
        modifier = Modifier
            .fillMaxSize()
            .padding(Spacing.lg)
    ) {
        Text("数据分析", style = MaterialTheme.typography.headlineMedium, fontWeight = FontWeight.Bold)
        Spacer(Modifier.height(Spacing.xl))

        // Placeholder
        Surface(
            modifier = Modifier.fillMaxSize(),
            color = card,
            shape = MaterialTheme.shapes.medium
        ) {
            Box(modifier = Modifier.fillMaxSize().padding(Spacing.xxxl)) {
                Text("📊 图表将在接入数据后显示", color = muted, style = MaterialTheme.typography.bodyLarge)
            }
        }
    }
}
