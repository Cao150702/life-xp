package com.lifequest.ui.settings

import androidx.compose.foundation.layout.*
import androidx.compose.material3.*
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import com.lifequest.ui.theme.*

@Composable
fun SettingsScreen() {
    Column(
        modifier = Modifier
            .fillMaxSize()
            .padding(Spacing.lg)
    ) {
        Text("设置", style = MaterialTheme.typography.headlineMedium, fontWeight = FontWeight.Bold)
        Spacer(Modifier.height(Spacing.xl))

        // Account section
        Surface(
            modifier = Modifier.fillMaxWidth(),
            color = card,
            shape = MaterialTheme.shapes.medium
        ) {
            Column(modifier = Modifier.padding(Spacing.xxl)) {
                Text("账号", style = MaterialTheme.typography.titleMedium, fontWeight = FontWeight.Bold, color = textPrimary)
                Spacer(Modifier.height(Spacing.md))
                // Placeholder
                Text("注册 / 导入导出 / 清空数据", color = muted)
            }
        }
    }
}
