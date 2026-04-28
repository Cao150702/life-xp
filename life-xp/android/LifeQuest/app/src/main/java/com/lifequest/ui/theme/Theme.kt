package com.lifequest.ui.theme

import android.os.Build
import androidx.compose.foundation.isSystemInDarkTheme
import androidx.compose.material3.*
import androidx.compose.runtime.Composable
import androidx.compose.ui.platform.LocalContext

private val DarkColorScheme = darkColorScheme(
    primary = brandPurple,
    secondary = brandBlue,
    tertiary = brandCyan,
    background = bg,
    surface = card,
    surfaceVariant = card2,
    onPrimary = Color.White,
    onSecondary = Color.White,
    onBackground = textPrimary,
    onSurface = textPrimary,
    onSurfaceVariant = textSecondary,
    outline = border,
    outlineVariant = border2,
    error = brandRed,
    onError = Color.White
)

@Composable
fun LifeQuestTheme(
    content: @Composable () -> Unit
) {
    val colorScheme = DarkColorScheme // Always dark

    MaterialTheme(
        colorScheme = colorScheme,
        typography = Typography,
        content = content
    )
}

// Spacing
object Spacing {
    val xs = 4.dp
    val sm = 8.dp
    val md = 12.dp
    val lg = 16.dp
    val xl = 20.dp
    val xxl = 24.dp
    val xxxl = 32.dp
}

// Corner Radius
object CornerRadius {
    val small = 14.dp
    val medium = 20.dp
    val large = 28.dp
}
