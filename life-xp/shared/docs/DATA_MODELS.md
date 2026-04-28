# LifeQuest 共享数据模型

> iOS / Android / Supabase 三端统一的数据定义

---

## 1. 用户档案 (Profile)

```sql
CREATE TABLE profiles (
    id          UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
    name        TEXT NOT NULL DEFAULT '',
    avatar      TEXT NOT NULL DEFAULT '🧑‍💻',
    total_xp    INTEGER NOT NULL DEFAULT 0,
    max_streak  INTEGER NOT NULL DEFAULT 0,
    created_at  TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at  TIMESTAMPTZ NOT NULL DEFAULT now()
);
```

```swift
// iOS - SwiftData
@Model
class Profile {
    @Attribute(.unique) var id: UUID
    var name: String
    var avatar: String
    var totalXP: Int
    var maxStreak: Int
    var createdAt: Date
    var updatedAt: Date
}
```

```kotlin
// Android - Room
@Entity(tableName = "profiles", primaryKeys = ["id"])
data class Profile(
    val id: String,       // UUID
    val name: String,
    val avatar: String,
    val totalXP: Int,
    val maxStreak: Int,
    val createdAt: Instant,
    val updatedAt: Instant
)
```

---

## 2. 活动记录 (Log)

```sql
CREATE TABLE logs (
    id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id     UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
    category    TEXT NOT NULL,           -- 'study' | 'research' | 'code' | 'sport' | 'read' | 'express' | custom
    title       TEXT NOT NULL,
    duration    INTEGER NOT NULL,        -- 分钟
    xp          INTEGER NOT NULL,
    note        TEXT DEFAULT '',
    log_date    DATE NOT NULL,           -- 打卡日期
    log_time    TIME NOT NULL,           -- 打卡时间
    created_at  TIMESTAMPTZ NOT NULL DEFAULT now(),
    synced_at   TIMESTAMPTZ,            -- 云端同步时间
    is_deleted  BOOLEAN NOT NULL DEFAULT false  -- 软删除
);

CREATE INDEX idx_logs_user_date ON logs(user_id, log_date DESC);
CREATE INDEX idx_logs_user_cat ON logs(user_id, category);
```

```swift
@Model
class LogEntry {
    @Attribute(.unique) var id: UUID
    var userId: UUID
    var category: String
    var title: String
    var duration: Int           // 分钟
    var xp: Int
    var note: String
    var logDate: Date
    var logTime: Date           // 只用 hour/minute
    var createdAt: Date
    var syncedAt: Date?
    var isDeleted: Bool
}
```

```kotlin
@Entity(
    tableName = "logs",
    foreignKeys = [ForeignKey(entity = Profile::class, parentColumns = ["id"], childColumns = ["userId"], onDelete = ForeignKey.CASCADE)],
    indices = [Index(value = ["userId", "logDate"]), Index(value = ["userId", "category"])]
)
data class LogEntry(
    @PrimaryKey val id: String,  // UUID
    val userId: String,
    val category: String,
    val title: String,
    val duration: Int,           // 分钟
    val xp: Int,
    val note: String,
    val logDate: LocalDate,
    val logTime: LocalTime,
    val createdAt: Instant,
    val syncedAt: Instant? = null,
    val isDeleted: Boolean = false
)
```

---

## 3. 自定义类别 (Custom Category)

```sql
CREATE TABLE custom_categories (
    id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id     UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
    cat_id      TEXT NOT NULL,           -- 自定义 ID, e.g. 'custom_1'
    name        TEXT NOT NULL,
    icon        TEXT NOT NULL,
    color       TEXT NOT NULL,           -- hex, e.g. '#FF6B6B'
    xp_per_min  INTEGER NOT NULL DEFAULT 2,
    sort_order  INTEGER NOT NULL DEFAULT 0,
    created_at  TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE UNIQUE INDEX idx_custom_cat_user_id ON custom_categories(user_id, cat_id);
```

---

## 4. 成就 (Achievement)

成就定义是**静态的**，硬编码在客户端（24 个成就不变）。
只有解锁记录存云端：

```sql
CREATE TABLE unlocked_achievements (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id         UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
    achievement_id  TEXT NOT NULL,           -- 'first', 'log10', etc.
    unlocked_at     TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE UNIQUE INDEX idx_ach_user ON unlocked_achievements(user_id, achievement_id);
```

---

## 5. 专注计时器快照 (Timer Snapshot)

```sql
CREATE TABLE timer_snapshots (
    id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id     UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
    category    TEXT NOT NULL,
    title       TEXT NOT NULL,
    started_at  TIMESTAMPTZ NOT NULL,
    -- 用户结束计时后，会创建一条 log 并删除此 snapshot
    created_at  TIMESTAMPTZ NOT NULL DEFAULT now()
);
```

---

## 6. 等级表（客户端静态）

```
Level  1:     0 XP    → 学徒
Level  2:   100 XP    → 学徒
Level  3:   250 XP    → 学者
Level  4:   450 XP    → 学者
Level  5:   700 XP    → 研究员
Level  6:  1050 XP    → 研究员
Level  7:  1500 XP    → 专家
Level  8:  2100 XP    → 专家
Level  9:  2900 XP    → 精英
Level 10:  3900 XP    → 精英
Level 11:  5200 XP    → 大师
Level 12:  6800 XP    → 大师
Level 13:  8700 XP    → 宗师
Level 14: 11000 XP    → 宗师
Level 15: 13800 XP    → 传说
Level 16: 17000 XP    → 传说
Level 17: 21000 XP    → 神话
Level 18: 26000 XP    → 神话
Level 19: 32000 XP    → 至圣
Level 20: 40000 XP    → 至圣
Level 21: 50000 XP    → 创世者
Level 22: 62000 XP    → 创世者
Level 23: 76000 XP    → 创世者
Level 24: 92000 XP    → 创世者
Level 25:110000 XP    → 创世者
```

职阶名: `['学徒','学者','研究员','专家','精英','大师','宗师','传说','神话','至圣','创世者']`
每个职阶占 2.5 级 (index = floor((lv-1)/2.5))

---

## 7. 导入数据格式 (v3 JSON)

从 Web 版导出的 JSON 格式，App 首次打开时支持导入：

```json
{
    "name": "天航",
    "avatar": "🧑‍💻",
    "logs": [
        {
            "id": "abc123",
            "cat": "study",
            "title": "线性代数复习",
            "dur": 90,
            "xp": 270,
            "note": "第三章",
            "date": "2026-04-28",
            "time": "14:30"
        }
    ],
    "totalXP": 5000,
    "maxStreak": 7,
    "customCats": [],
    "unlockedAch": ["first", "log10", "streak3"],
    "createdAt": "2026-03-15T10:00:00.000Z"
}
```

---

## 8. 同步策略

### 离线优先 (Offline-First)

1. **所有操作先写本地** → 立即返回 UI 响应
2. **后台异步同步到 Supabase** → Realtime subscription 监听变化
3. **冲突解决**: Last-Write-Wins (服务端 `updated_at` 时间戳)
4. **软删除**: 本地标记 `isDeleted`，同步时在云端执行实际删除

### 同步流程

```
本地写入 → 加入同步队列 → 网络可用时批量上传
                              ↓
Realtime subscription ← 服务端推送其他设备的变化 → 本地合并
```

### 首次登录/注册

1. 匿名 Auth → 自动创建 Profile（空）
2. 用户完成引导 → 更新 Profile (name, avatar)
3. 用户选择注册 → 匿名账号升级为邮箱/手机号账号
4. 用户选择导入 → 解析 v3 JSON → 批量插入 logs → 更新 totals
