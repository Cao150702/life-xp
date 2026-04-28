package com.lifequest.ui.achievements

import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.grid.GridCells
import androidx.compose.foundation.lazy.grid.LazyVerticalGrid
import androidx.compose.foundation.lazy.grid.items
import androidx.compose.material3.*
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.text.font.FontWeight
import com.lifequest.data.model.Achievement
import com.lifequest.data.model.Rarity
import com.lifequest.ui.theme.*

@Composable
fun AchievementsScreen() {
    Column(
        modifier = Modifier
            .fillMaxSize()
            .padding(Spacing.lg)
    ) {
        Text("成就", style = MaterialTheme.typography.headlineMedium, fontWeight = FontWeight.Bold)
        Spacer(Modifier.height(Spacing.xl))

        LazyVerticalGrid(
            columns = GridCells.Fixed(2),
            horizontalArrangement = Arrangement.spacedBy(Spacing.md),
            verticalArrangement = Arrangement.spacedBy(Spacing.md)
        ) {
            items(Achievement.all) { ach ->
                AchievementCard(ach, isUnlocked = false, progress = 0, max = 1)
            }
        }
    }
}

@Composable
fun AchievementCard(ach: Achievement, isUnlocked: Boolean, progress: Int, max: Int) {
    Surface(
        color = if (isUnlocked) brandAmber.copy(alpha = 0.06f) else card,
        shape = MaterialTheme.shapes.small
    ) {
        Column(
            modifier = Modifier.padding(Spacing.md),
            horizontalAlignment = androidx.compose.ui.Alignment.CenterHorizontally
        ) {
            // Rarity Badge
            val rarityColor = when (ach.rarity) {
                Rarity.COMMON -> brandBlue
                Rarity.RARE -> brandPurple
                Rarity.EPIC -> brandPink
                Rarity.LEGENDARY -> brandAmber
            }

            Surface(color = rarityColor.copy(alpha = 0.15f), shape = MaterialTheme.shapes.extraSmall) {
                Text(ach.rarity.label, style = MaterialTheme.typography.labelSmall, color = rarityColor, fontWeight = FontWeight.Bold, modifier = Modifier.padding(horizontal = 6.dp, vertical = 2.dp))
            }

            Spacer(Modifier.height(Spacing.sm))
            Text(ach.icon, fontSize = MaterialTheme.typography.displayLarge.fontSize * 0.6f)
            Text(ach.name, style = MaterialTheme.typography.labelLarge, fontWeight = FontWeight.Bold, color = if (isUnlocked) rarityColor else textPrimary)
            Text(ach.desc, style = MaterialTheme.typography.labelSmall, color = muted, maxLines = 2)

            if (!isUnlocked) {
                Spacer(Modifier.height(Spacing.sm))
                LinearProgressIndicator(
                    progress = { if (max > 0) progress.toFloat() / max else 0f },
                    modifier = Modifier.fillMaxWidth().height(4.dp),
                    color = brandAmber,
                    trackColor = bg2
                )
                Text("$progress/$max", style = MaterialTheme.typography.labelSmall, color = muted)
            }
        }
    }
}
