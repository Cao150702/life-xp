package com.lifequest.ui.home

import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyRow
import androidx.compose.foundation.lazy.items
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.lifequest.data.model.Category
import com.lifequest.ui.theme.*

@Composable
fun TimerScreen() {
    var selectedCategory by remember { mutableStateOf(Category.builtIn[0]) }
    var isRunning by remember { mutableStateOf(false) }
    var elapsedSeconds by remember { mutableIntStateOf(0) }
    var timerTitle by remember { mutableStateOf("") }

    // Timer tick
    LaunchedEffect(isRunning) {
        while (isRunning) {
            kotlinx.coroutines.delay(1000)
            elapsedSeconds++
        }
    }

    Column(
        modifier = Modifier.fillMaxSize().padding(Spacing.xxl),
        horizontalAlignment = Alignment.CenterHorizontally
    ) {
        Spacer(Modifier.weight(1f))

        // Timer Display
        Surface(
            modifier = Modifier.fillMaxWidth(),
            color = card,
            shape = MaterialTheme.shapes.large
        ) {
            Column(
                modifier = Modifier.padding(Spacing.xxxl),
                horizontalAlignment = Alignment.CenterHorizontally
            ) {
                val hours = elapsedSeconds / 3600
                val minutes = (elapsedSeconds % 3600) / 60
                val seconds = elapsedSeconds % 60
                val timeStr = if (hours > 0) "%d:%02d:%02d".format(hours, minutes, seconds) else "%02d:%02d".format(minutes, seconds)

                Text(
                    timeStr,
                    style = MaterialTheme.typography.displayLarge.copy(fontWeight = FontWeight.Thin),
                    fontSize = 64.sp,
                    color = if (isRunning) brandPurple else textPrimary
                )

                if (isRunning) {
                    Text("${selectedCategory.icon} ${selectedCategory.name}", color = brandCyan, style = MaterialTheme.typography.bodyMedium)
                }
            }
        }

        Spacer(Modifier.height(Spacing.xxxl))

        // Title Input
        OutlinedTextField(
            value = timerTitle,
            onValueChange = { timerTitle = it },
            placeholder = { Text("做了什么？", color = muted) },
            modifier = Modifier.fillMaxWidth(),
            colors = OutlinedTextFieldDefaults.colors(
                focusedBorderColor = brandPurple,
                unfocusedBorderColor = border,
                textColor = textPrimary,
                containerColor = card
            )
        )

        Spacer(Modifier.height(Spacing.lg))

        // Category Scroll
        LazyRow(horizontalArrangement = Arrangement.spacedBy(Spacing.sm)) {
            items(Category.builtIn) { cat ->
                FilterChip(
                    selected = selectedCategory.id == cat.id,
                    onClick = { selectedCategory = cat },
                    label = { Text("${cat.icon} ${cat.name}") },
                    colors = FilterChipDefaults.filterChipColors(
                        selectedContainerColor = brandPurple.copy(alpha = 0.2f),
                        selectedLabelColor = brandPurple
                    )
                )
            }
        }

        Spacer(Modifier.weight(1f))

        // Controls
        Row(horizontalArrangement = Arrangement.spacedBy(Spacing.xl), verticalAlignment = Alignment.CenterVertically) {
            // Reset
            IconButton(onClick = { elapsedSeconds = 0; isRunning = false }, modifier = Modifier.size(56.dp)) {
                Surface(color = card, shape = MaterialTheme.shapes.extraLarge) {
                    Box(Modifier.size(56.dp), contentAlignment = Alignment.Center) {
                        Text("↺", color = textSecondary)
                    }
                }
            }

            // Start/Pause
            Button(
                onClick = { isRunning = !isRunning },
                modifier = Modifier.size(80.dp),
                colors = ButtonDefaults.buttonColors(containerColor = if (isRunning) brandGreen else brandPurple),
                shape = MaterialTheme.shapes.extraLarge
            ) {
                Text(if (isRunning) "⏸" else "▶", fontSize = 28.sp)
            }

            // Submit
            IconButton(
                onClick = { /* TODO: submit */ elapsedSeconds = 0; isRunning = false },
                enabled = elapsedSeconds > 0,
                modifier = Modifier.size(56.dp)
            ) {
                Surface(color = brandPurple, shape = MaterialTheme.shapes.extraLarge) {
                    Box(Modifier.size(56.dp), contentAlignment = Alignment.Center) {
                        Text("✓", color = textPrimary, fontWeight = FontWeight.Bold)
                    }
                }
            }
        }

        Spacer(Modifier.height(Spacing.xl))
    }
}
