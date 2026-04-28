package com.lifequest.ui.navigation

import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.padding
import androidx.compose.material3.*
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.ui.Modifier
import androidx.navigation.NavDestination.Companion.hierarchy
import androidx.navigation.NavGraph.Companion.findStartDestination
import androidx.navigation.compose.NavHost
import androidx.navigation.compose.composable
import androidx.navigation.compose.currentBackStackEntryAsState
import androidx.navigation.compose.rememberNavController
import com.lifequest.ui.analytics.AnalyticsScreen
import com.lifequest.ui.achievements.AchievementsScreen
import com.lifequest.ui.home.HomeScreen
import com.lifequest.ui.home.QuickLogScreen
import com.lifequest.ui.home.TimerScreen
import com.lifequest.ui.onboarding.OnboardingScreen
import com.lifequest.ui.settings.SettingsScreen
import com.lifequest.ui.theme.*

sealed class Screen(val route: String) {
    data object Onboarding : Screen("onboarding")
    data object Home : Screen("home")
    data object Timer : Screen("timer")
    data object QuickLog : Screen("quicklog")
    data object Analytics : Screen("analytics")
    data object Achievements : Screen("achievements")
    data object Settings : Screen("settings")
}

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun LifeQuestApp(
    needsOnboarding: Boolean
) {
    val navController = rememberNavController()

    if (needsOnboarding) {
        OnboardingScreen(
            onComplete = {
                // TODO: navigate to main
            }
        )
        return
    }

    Scaffold(
        bottomBar = {
            NavigationBar(
                containerColor = card,
                contentColor = textPrimary
            ) {
                val navBackStackEntry by navController.currentBackStackEntryAsState()
                val currentDestination = navBackStackEntry?.destination

                val items = listOf(
                    Screen.Home to "首页",
                    Screen.Timer to "专注",
                    Screen.QuickLog to "记录",
                    Screen.Analytics to "分析",
                    Screen.Achievements to "成就",
                )

                items.forEach { (screen, label) ->
                    NavigationBarItem(
                        icon = { /* TODO: icons */ },
                        label = { Text(label, style = MaterialTheme.typography.labelSmall) },
                        selected = currentDestination?.hierarchy?.any { it.route == screen.route } == true,
                        onClick = {
                            navController.navigate(screen.route) {
                                popUpTo(navController.graph.findStartDestination().id) {
                                    saveState = true
                                }
                                launchSingleTop = true
                                restoreState = true
                            }
                        },
                        colors = NavigationBarItemDefaults.colors(
                            indicatorColor = brandPurple.copy(alpha = 0.15f),
                            selectedIconColor = brandPurple,
                            selectedTextColor = brandPurple
                        )
                    )
                }
            }
        },
        containerColor = bg
    ) { innerPadding ->
        NavHost(
            navController = navController,
            startDestination = Screen.Home.route,
            modifier = Modifier
                .fillMaxSize()
                .padding(innerPadding)
        ) {
            composable(Screen.Home.route) { HomeScreen() }
            composable(Screen.Timer.route) { TimerScreen() }
            composable(Screen.QuickLog.route) { QuickLogScreen() }
            composable(Screen.Analytics.route) { AnalyticsScreen() }
            composable(Screen.Achievements.route) { AchievementsScreen() }
            composable(Screen.Settings.route) { SettingsScreen() }
        }
    }
}
