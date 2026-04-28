package com.lifequest.data.model

import java.time.LocalDate
import java.time.LocalTime
import java.util.UUID

// ==================== Level System ====================

object LevelSystem {
    val thresholds = listOf(
        0, 100, 250, 450, 700, 1050, 1500, 2100, 2900, 3900,
        5200, 6800, 8700, 11000, 13800, 17000, 21000, 26000,
        32000, 40000, 50000, 62000, 76000, 92000, 110000
    )

    val classNames = listOf(
        "学徒", "学者", "研究员", "专家", "精英",
        "大师", "宗师", "传说", "神话", "至圣", "创世者"
    )

    fun level(xp: Int): Int {
        for (i in thresholds.indices.reversed()) {
            if (xp >= thresholds[i]) return i + 1
        }
        return 1
    }

    fun className(level: Int): String {
        val index = minOf(kotlin.math.floor((level - 1) / 2.5).toInt(), classNames.lastIndex)
        return classNames[index]
    }

    data class LevelInfo(
        val level: Int,
        val currentThreshold: Int,
        val nextThreshold: Int,
        val progress: Float,
        val remaining: Int
    )

    fun levelInfo(xp: Int): LevelInfo {
        val lv = level(xp)
        val cur = thresholds[lv - 1]
        val nxt = if (lv < thresholds.size) thresholds[lv] else (cur * 1.5).toInt()
        val range = (nxt - cur).toFloat()
        val progress = if (range > 0) minOf((xp - cur).toFloat() / range, 1f) else 1f
        return LevelInfo(lv, cur, nxt, progress, maxOf(nxt - xp, 0))
    }
}

// ==================== Category ====================

data class Category(
    val id: String,
    val name: String,
    val icon: String,
    val color: String,
    val xpPerMin: Int,
    val desc: String,
    val isCustom: Boolean = false
) {
    companion object {
        val builtIn = listOf(
            Category("study", "学习", "📚", "#8B5CF6", 3, "读书、上课、复习"),
            Category("research", "科研", "🔬", "#3B82F6", 4, "实验、论文、课题"),
            Category("code", "编程", "💻", "#06B6D4", 4, "写代码、debug、项目"),
            Category("sport", "运动", "🏃", "#10B981", 2, "跑步、健身、球类"),
            Category("read", "阅读", "📖", "#F59E0B", 2, "课外书、文章、博客"),
            Category("express", "表达", "🎤", "#EC4899", 3, "写作、演讲、分享"),
        )

        val avatars = listOf("🧑‍💻","👩‍🎓","🧑‍🔬","🧑‍🎨","🧙","🦸","🐉","🎮","🧑‍🚀","🦊","🐱","🦁")
    }
}

// ==================== Achievement ====================

enum class Rarity(val label: String) {
    COMMON("普通"),
    RARE("稀有"),
    EPIC("史诗"),
    LEGENDARY("传说")
}

data class Achievement(
    val id: String,
    val icon: String,
    val name: String,
    val desc: String,
    val rarity: Rarity
) {
    companion object {
        val all = listOf(
            Achievement("first", "🌱", "破壳而出", "完成第一次打卡", Rarity.COMMON),
            Achievement("log10", "📝", "初露锋芒", "累计打卡 10 次", Rarity.COMMON),
            Achievement("log50", "⚡", "勤奋之星", "累计打卡 50 次", Rarity.RARE),
            Achievement("log100", "💎", "百炼成钢", "累计打卡 100 次", Rarity.RARE),
            Achievement("log500", "🏅", "千锤百炼", "累计打卡 500 次", Rarity.EPIC),
            Achievement("streak3", "🔥", "三连击", "连续打卡 3 天", Rarity.COMMON),
            Achievement("streak7", "🌟", "一周达人", "连续打卡 7 天", Rarity.RARE),
            Achievement("streak14", "💫", "两周坚持", "连续打卡 14 天", Rarity.RARE),
            Achievement("streak30", "👑", "月度王者", "连续打卡 30 天", Rarity.EPIC),
            Achievement("streak60", "🏆", "双月传奇", "连续打卡 60 天", Rarity.EPIC),
            Achievement("streak100", "🔱", "百日筑基", "连续打卡 100 天", Rarity.LEGENDARY),
            Achievement("xp500", "✨", "初窥门径", "总经验达到 500", Rarity.COMMON),
            Achievement("xp2k", "🥈", "小有所成", "总经验达到 2000", Rarity.RARE),
            Achievement("xp5k", "🥇", "成果丰硕", "总经验达到 5000", Rarity.RARE),
            Achievement("xp20k", "💎", "大器晚成", "总经验达到 20000", Rarity.EPIC),
            Achievement("xp50k", "🌟", "登峰造极", "总经验达到 50000", Rarity.LEGENDARY),
            Achievement("lv5", "⚔️", "小试牛刀", "角色达到 5 级", Rarity.COMMON),
            Achievement("lv10", "🐉", "实力进阶", "角色达到 10 级", Rarity.RARE),
            Achievement("lv20", "🔥", "巅峰之路", "角色达到 20 级", Rarity.EPIC),
            Achievement("hr2", "⏰", "深度专注", "单次专注超 2 小时", Rarity.RARE),
            Achievement("variety", "🌈", "全面发展", "所有类别都有记录", Rarity.EPIC),
            Achievement("night", "🌙", "夜猫子", "22:00 后打卡", Rarity.COMMON),
            Achievement("morning", "🌅", "早起鸟", "06:00 前打卡", Rarity.COMMON),
            Achievement("day1k", "💪", "日进千XP", "单日经验超过 1000", Rarity.EPIC),
        )
    }
}

// ==================== Utility ====================

fun fmtNum(n: Int): String {
    return when {
        n >= 10000 -> String.format("%.1fw", n / 10000.0)
        n >= 1000 -> String.format("%.1fk", n / 1000.0)
        else -> n.toString()
    }
}
