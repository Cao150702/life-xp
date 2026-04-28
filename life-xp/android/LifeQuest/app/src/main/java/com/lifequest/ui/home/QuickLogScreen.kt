package com.lifequest.ui.home

import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.grid.GridCells
import androidx.compose.foundation.lazy.grid.LazyVerticalGrid
import androidx.compose.foundation.lazy.grid.items
import androidx.compose.foundation.text.KeyboardOptions
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Modifier
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.input.KeyboardType
import androidx.compose.ui.unit.dp
import com.lifequest.data.model.Category
import com.lifequest.ui.theme.*

@Composable
fun QuickLogScreen() {
    var selectedCategory by remember { mutableStateOf<Category?>(null) }
    var title by remember { mutableStateOf("") }
    var duration by remember { mutableStateOf("") }
    var note by remember { mutableStateOf("") }

    val canSubmit = selectedCategory != null && title.isNotBlank() && (duration.toIntOrNull() ?: 0) > 0

    Column(
        modifier = Modifier
            .fillMaxSize()
            .padding(Spacing.lg)
    ) {
        Text("选择类别", style = MaterialTheme.typography.labelLarge, color = muted, fontWeight = FontWeight.Bold)
        Spacer(Modifier.height(Spacing.md))

        LazyVerticalGrid(
            columns = GridCells.Fixed(3),
            horizontalArrangement = Arrangement.spacedBy(Spacing.md),
            verticalArrangement = Arrangement.spacedBy(Spacing.md)
        ) {
            items(Category.builtIn) { cat ->
                FilterChip(
                    selected = selectedCategory?.id == cat.id,
                    onClick = { selectedCategory = cat },
                    label = {
                        Column(horizontalAlignment = androidx.compose.ui.Alignment.CenterHorizontally) {
                            Text(cat.icon, fontSize = MaterialTheme.typography.titleLarge.fontSize)
                            Text(cat.name, style = MaterialTheme.typography.labelLarge)
                        }
                    },
                    modifier = Modifier.padding(vertical = Spacing.sm)
                )
            }
        }

        Spacer(Modifier.height(Spacing.xl))

        OutlinedTextField(
            value = title,
            onValueChange = { title = it },
            label = { Text("做了什么") },
            modifier = Modifier.fillMaxWidth(),
            colors = OutlinedTextFieldDefaults.colors(focusedBorderColor = brandPurple, unfocusedBorderColor = border, textColor = textPrimary, containerColor = card)
        )

        Spacer(Modifier.height(Spacing.md))

        OutlinedTextField(
            value = duration,
            onValueChange = { duration = it },
            label = { Text("时长（分钟）") },
            modifier = Modifier.fillMaxWidth(),
            keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Number),
            colors = OutlinedTextFieldDefaults.colors(focusedBorderColor = brandPurple, unfocusedBorderColor = border, textColor = textPrimary, containerColor = card)
        )

        Spacer(Modifier.height(Spacing.md))

        OutlinedTextField(
            value = note,
            onValueChange = { note = it },
            label = { Text("备注（可选）") },
            modifier = Modifier.fillMaxWidth(),
            colors = OutlinedTextFieldDefaults.colors(focusedBorderColor = brandPurple, unfocusedBorderColor = border, textColor = textPrimary, containerColor = card)
        )

        Spacer(Modifier.height(Spacing.lg))

        // XP Preview
        if (selectedCategory != null) {
            val dur = duration.toIntOrNull() ?: 0
            if (dur > 0) {
                Surface(color = brandEmerald.copy(alpha = 0.1f), shape = MaterialTheme.shapes.small) {
                    Row(modifier = Modifier.padding(Spacing.md)) {
                        Text("⚡ 预计 +${dur * selectedCategory!!.xpPerMin} XP", color = brandEmerald, fontWeight = FontWeight.Bold)
                    }
                }
                Spacer(Modifier.height(Spacing.md))
            }
        }

        Spacer(Modifier.weight(1f))

        Button(
            onClick = { /* TODO: submit */ selectedCategory = null; title = ""; duration = ""; note = "" },
            modifier = Modifier.fillMaxWidth().height(54.dp),
            colors = ButtonDefaults.buttonColors(containerColor = if (canSubmit) brandPurple else muted.copy(alpha = 0.3f)),
            shape = MaterialTheme.shapes.small,
            enabled = canSubmit
        ) {
            Text("提交记录", fontWeight = FontWeight.Bold)
        }
    }
}
