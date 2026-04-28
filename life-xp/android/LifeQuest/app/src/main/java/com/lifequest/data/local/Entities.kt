package com.lifequest.data.local

import androidx.room.Entity
import androidx.room.ForeignKey
import androidx.room.Index
import androidx.room.PrimaryKey
import java.time.Instant
import java.time.LocalDate
import java.time.LocalTime

@Entity(tableName = "profiles", primaryKeys = ["id"])
data class ProfileEntity(
    val id: String,
    val name: String,
    val avatar: String,
    val totalXp: Int,
    val maxStreak: Int,
    val createdAt: Instant,
    val updatedAt: Instant
)

@Entity(
    tableName = "logs",
    foreignKeys = [
        ForeignKey(
            entity = ProfileEntity::class,
            parentColumns = ["id"],
            childColumns = ["userId"],
            onDelete = ForeignKey.CASCADE
        )
    ],
    indices = [
        Index(value = ["userId", "logDate"]),
        Index(value = ["userId", "category"])
    ]
)
data class LogEntity(
    @PrimaryKey val id: String,
    val userId: String,
    val category: String,
    val title: String,
    val duration: Int,
    val xp: Int,
    val note: String,
    val logDate: LocalDate,
    val logTime: LocalTime,
    val createdAt: Instant,
    val syncedAt: Instant? = null,
    val isDeleted: Boolean = false
)

@Entity(
    tableName = "custom_categories",
    foreignKeys = [
        ForeignKey(
            entity = ProfileEntity::class,
            parentColumns = ["id"],
            childColumns = ["userId"],
            onDelete = ForeignKey.CASCADE
        )
    ],
    indices = [Index(value = ["userId", "catId"], unique = true)]
)
data class CustomCategoryEntity(
    @PrimaryKey val id: String,
    val userId: String,
    val catId: String,
    val name: String,
    val icon: String,
    val color: String,
    val xpPerMin: Int,
    val sortOrder: Int,
    val createdAt: Instant
)

@Entity(
    tableName = "sync_records",
    indices = [Index(value = ["status"])]
)
data class SyncRecordEntity(
    @PrimaryKey val id: String,
    val tableName: String,
    val recordId: String,
    val operation: String, // "insert", "update", "delete"
    val payload: String,   // JSON
    val createdAt: Instant,
    val retryCount: Int,
    val status: String     // "pending", "syncing", "failed", "done"
)
