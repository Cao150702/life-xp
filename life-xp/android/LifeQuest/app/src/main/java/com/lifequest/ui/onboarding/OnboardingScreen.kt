package com.lifequest.ui.onboarding

import androidx.compose.foundation.layout.*
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.hilt.navigation.compose.hiltViewModel
import com.lifequest.data.model.Category
import com.lifequest.ui.theme.*

@Composable
fun OnboardingScreen(
    onComplete: () -> Unit,
    viewModel: OnboardingViewModel = hiltViewModel()
) {
    var step by remember { mutableIntStateOf(0) }

    Surface(
        modifier = Modifier.fillMaxSize(),
        color = bg
    ) {
        Column(
            modifier = Modifier
                .fillMaxSize()
                .padding(Spacing.xxl),
            horizontalAlignment = Alignment.CenterHorizontally
        ) {
            Spacer(Modifier.weight(1f))

            when (step) {
                0 -> WelcomeStep()
                1 -> NameStep(viewModel.name) { viewModel.name = it }
                2 -> AvatarStep(viewModel.avatar) { viewModel.avatar = it }
            }

            Spacer(Modifier.weight(1f))

            Button(
                onClick = {
                    if (step < 2) step++
                    else viewModel.completeOnboarding(onComplete)
                },
                modifier = Modifier
                    .fillMaxWidth()
                    .height(54.dp),
                colors = ButtonDefaults.buttonColors(containerColor = brandPurple),
                shape = MaterialTheme.shapes.small,
                enabled = step != 1 || viewModel.name.isNotBlank()
            ) {
                Text(
                    if (step == 2) "开始冒险 →" else "下一步",
                    style = MaterialTheme.typography.titleMedium,
                    fontWeight = FontWeight.Bold
                )
            }

            Spacer(Modifier.height(Spacing.xxxl))
        }
    }
}

@Composable
private fun WelcomeStep() {
    Column(horizontalAlignment = Alignment.CenterHorizontally, verticalArrangement = Arrangement.spacedBy(Spacing.xl)) {
        Text("⚔️", fontSize = MaterialTheme.typography.displayLarge.fontSize)
        Text(
            "LifeQuest",
            style = MaterialTheme.typography.headlineLarge,
            fontWeight = FontWeight.Black,
            color = brandPurple
        )
        Text("把每一次努力变成看得见的成长", color = textSecondary)
    }
}

@Composable
private fun NameStep(name: String, onNameChange: (String) -> Unit) {
    Column(horizontalAlignment = Alignment.CenterHorizontally, verticalArrangement = Arrangement.spacedBy(Spacing.xl)) {
        Text("你叫什么名字？", style = MaterialTheme.typography.headlineMedium, fontWeight = FontWeight.Bold)
        OutlinedTextField(
            value = name,
            onValueChange = onNameChange,
            placeholder = { Text("输入你的名字", color = muted) },
            modifier = Modifier.fillMaxWidth(),
            colors = OutlinedTextFieldDefaults.colors(
                focusedBorderColor = brandPurple,
                unfocusedBorderColor = border,
                textColor = textPrimary,
                containerColor = card
            )
        )
    }
}

@Composable
private fun AvatarStep(avatar: String, onAvatarChange: (String) -> Unit) {
    Column(horizontalAlignment = Alignment.CenterHorizontally, verticalArrangement = Arrangement.spacedBy(Spacing.xl)) {
        Text("选择你的角色", style = MaterialTheme.typography.headlineMedium, fontWeight = FontWeight.Bold)
        Text(avatar, fontSize = MaterialTheme.typography.displayLarge.fontSize)
        Category.avatars.chunked(4).forEach { row ->
            Row(horizontalArrangement = Arrangement.spacedBy(Spacing.md)) {
                row.forEach { av ->
                    Surface(
                        onClick = { onAvatarChange(av) },
                        shape = MaterialTheme.shapes.extraLarge,
                        color = if (av == avatar) brandPurple.copy(alpha = 0.2f) else card,
                        border = if (av == avatar) ButtonDefaults.outlinedButtonBorder.copy(brush = null) else null,
                        modifier = Modifier.size(64.dp)
                    ) {
                        Box(contentAlignment = Alignment.Center) { Text(av, fontSize = MaterialTheme.typography.headlineLarge.fontSize) }
                    }
                }
            }
        }
    }
}
