package com.lifequest.ui.home

import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.grid.*
import androidx.compose.material3.*
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import com.lifequest.data.model.Category
import com.lifequest.data.model.LevelSystem
import com.lifequest.data.model.fmtNum
import com.lifequest.ui.theme.*

@Composable
fun HomeScreen() {
    // TODO: Inject ViewModel with real data
    val totalXP = 0
    val todayXP = 0
    val todayMin = 0
    val streak = 0
    val levelInfo = LevelSystem.levelInfo(totalXP)
    val userName = "天航"
    val userAvatar = "🧑‍💻"

    Column(
        modifier = Modifier
            .fillMaxSize()
            .padding(Spacing.lg)
    ) {
        // Hero Card
        Surface(
            modifier = Modifier.fillMaxWidth(),
            color = card,
            shape = MaterialTheme.shapes.large,
            tonalElevation = 0.dp
        ) {
            Column(modifier = Modifier.padding(Spacing.xl)) {
                Row(verticalAlignment = Alignment.CenterVertically) {
                    Text(userAvatar, fontSize = MaterialTheme.typography.displayLarge.fontSize * 0.7f)
                    Spacer(Modifier.width(Spacing.md))
                    Column {
                        Text(userName, style = MaterialTheme.typography.titleMedium, fontWeight = FontWeight.Bold)
                        Text("✦ ${LevelSystem.className(levelInfo.level)} ✦", color = brandPurple2, style = MaterialTheme.typography.labelLarge)
                    }
                    Spacer(Modifier.weight(1f))
                    Column(horizontalAlignment = Alignment.CenterHorizontally) {
                        Text("Lv", style = MaterialTheme.typography.labelSmall, color = muted)
                        Text("${levelInfo.level}", style = MaterialTheme.typography.displayLarge, color = brandPurple, fontWeight = FontWeight.Black)
                    }
                }

                Spacer(Modifier.height(Spacing.lg))

                // XP Progress
                LinearProgressIndicator(
                    progress = { levelInfo.progress },
                    modifier = Modifier.fillMaxWidth().height(8.dp),
                    color = brandPurple,
                    trackColor = bg2,
                )
                Row(Modifier.fillMaxWidth().padding(top = Spacing.sm)) {
                    Text("${fmtNum(totalXP - levelInfo.currentThreshold)} / ${fmtNum(levelInfo.nextThreshold - levelInfo.currentThreshold)}", style = MaterialTheme.typography.labelSmall, color = muted)
                    Spacer(Modifier.weight(1f))
                    Text("还差 ${fmtNum(levelInfo.remaining)} XP", style = MaterialTheme.typography.labelSmall, color = brandPurple2, fontWeight = FontWeight.SemiBold)
                }
            }
        }

        Spacer(Modifier.height(Spacing.xl))

        // Stats Row
        Row(horizontalArrangement = Arrangement.spacedBy(Spacing.md), modifier = Modifier.fillMaxWidth()) {
            StatCard("今日 XP", fmtNum(todayXP), "⚡")
            StatCard("今日分钟", fmtNum(todayMin), "⏱")
            StatCard("连续天数", "$streak", "🔥")
        }

        Spacer(Modifier.height(Spacing.xl))

        // Skills
        Text("技能等级", style = MaterialTheme.typography.titleMedium, fontWeight = FontWeight.Bold)
        Spacer(Modifier.height(Spacing.md))

        LazyVerticalGrid(
            columns = GridCells.Fixed(2),
            horizontalArrangement = Arrangement.spacedBy(Spacing.md),
            verticalArrangement = Arrangement.spacedBy(Spacing.md),
            modifier = Modifier.fillMaxSize()
        ) {
            items(Category.builtIn) { cat ->
                // TODO: real XP per category
                SkillCard(cat, 0)
            }
        }
    }
}

@Composable
fun StatCard(title: String, value: String, icon: String) {
    Surface(
        modifier = Modifier.weight(1f),
        color = card,
        shape = MaterialTheme.shapes.small
    ) {
        Column(
            modifier = Modifier.padding(Spacing.lg),
            horizontalAlignment = Alignment.CenterHorizontally
        ) {
            Text(icon, fontSize = MaterialTheme.typography.titleLarge.fontSize)
            Text(value, style = MaterialTheme.typography.titleMedium, fontWeight = FontWeight.Black, color = textPrimary)
            Text(title, style = MaterialTheme.typography.labelSmall, color = muted, fontWeight = FontWeight.SemiBold)
        }
    }
}

@Composable
fun SkillCard(cat: Category, xp: Int) {
    val info = LevelSystem.levelInfo(xp)
    Surface(
        color = card,
        shape = MaterialTheme.shapes.small
    ) {
        Column(modifier = Modifier.padding(Spacing.lg)) {
            Row(verticalAlignment = Alignment.CenterVertically) {
                // Icon
                Surface(shape = MaterialTheme.shapes.extraLarge, color = brandPurple.copy(alpha = 0.1f)) {
                    Box(modifier = Modifier.padding(Spacing.sm)) { Text(cat.icon) }
                }
                Spacer(Modifier.width(Spacing.sm))
                Column {
                    Text(cat.name, style = MaterialTheme.typography.bodyMedium, fontWeight = FontWeight.SemiBold)
                    Text("Lv${info.level}", style = MaterialTheme.typography.labelMedium, fontWeight = FontWeight.Bold, color = brandCyan)
                }
            }
            Spacer(Modifier.height(Spacing.sm))
            LinearProgressIndicator(progress = { info.progress }, modifier = Modifier.fillMaxWidth().height(4.dp), color = brandCyan, trackColor = bg2)
            Text("${fmtNum(xp)} XP", style = MaterialTheme.typography.labelSmall, color = muted)
        }
    }
}
