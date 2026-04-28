# LifeQuest Auth & 同步配置指南

> Supabase Auth 匿名登录 + 可选注册升级 + 离线同步

---

## 1. Supabase 项目设置

### 1.1 创建项目

1. 登录 [supabase.com/dashboard](https://supabase.com/dashboard)
2. New Project → 填写:
   - Name: `lifequest`
   - Database Password: (自行设置强密码)
   - Region: `Northeast Asia (Tokyo)` 或 `Southeast Asia (Singapore)`
3. 等待项目初始化完成（约 2 分钟）

### 1.2 运行数据库迁移

1. 进入 SQL Editor
2. 粘贴 `supabase/migrations/001_initial_schema.sql` 全部内容
3. 点击 Run
4. 确认所有表创建成功（左侧 Tables 列表可见）

### 1.3 配置 Auth

进入 **Authentication → Providers**：

#### 启用 Anonymous（匿名登录）

- 开关: ON
- 无需额外配置

#### 启用 Email（邮箱注册）

- 开关: ON
- Confirm email: OFF（可选，建议先关掉方便测试）
- Secure email change: ON

#### 启用 Phone（手机号注册，可选）

- 开关: ON
- 需要配置 SMS Provider（推荐 Twilio 或 MessageBird）

---

## 2. Auth 流程设计

```
App 启动
    │
    ├── 本地无 token → 匿名登录 → 获得临时 user
    │                       │
    │                       └── 完成引导 → 创建 Profile (name, avatar)
    │
    ├── 本地有 token → 尝试恢复 session
    │                       │
    │                       ├── 成功 → 加载 Profile → 进入主页
    │                       └── 失败 → 匿名登录（新用户或 token 过期）
    │
    └── 用户选择注册 → 匿名账号升级
                            │
                            ├── 邮箱 → supabase.auth.linkAnonymousWithOtp()
                            └── 手机号 → supabase.auth.linkAnonymousWithPhone()
```

### iOS 实现

```swift
import Supabase

let client = SupabaseClient(supabaseURL: URL(string: "https://xxx.supabase.co")!, supabaseKey: "eyJ...")

// 匿名登录
try await client.auth.signInAnonymously()

// 检查当前 session
let session = try await client.auth.session

// 匿名升级为邮箱注册
try await client.auth.linkAnonymousWithOtp(email: "user@example.com")

// 匿名升级为手机号注册
try await client.auth.linkAnonymousWithPhone(phone: "+8613800138000")
```

### Android 实现

```kotlin
val client = createSupabaseClient(
    supabaseUrl = "https://xxx.supabase.co",
    supabaseKey = "eyJ..."
) {
    install(Auth)
    install(Realtime)
    install(Postgrest)
}

// 匿名登录
client.auth.signInAnonymously()

// 检查当前 session
val session = client.auth.currentSessionOrNull()

// 匿名升级
client.auth.linkAnonymously(EmailOtp) {
    email = "user@example.com"
}
```

---

## 3. 离线同步引擎

### 架构

```
┌─────────────────────────────────────────────┐
│                    App UI                    │
└────────────────────┬────────────────────────┘
                     │
┌────────────────────▼────────────────────────┐
│              ViewModel (Zustand/BLoC)        │
│  - 读本地数据库                               │
│  - 写入后标记为 "待同步"                       │
└────────────────────┬────────────────────────┘
                     │
┌────────────────────▼────────────────────────┐
│            SyncEngine (核心同步引擎)           │
│  - 监听网络状态                                │
│  - 同步队列管理                                │
│  - 冲突解决 (LWW)                             │
│  - Realtime subscription                      │
└──────────┬───────────────────────┬───────────┘
           │                       │
┌──────────▼──────────┐  ┌────────▼────────────┐
│   本地数据库          │  │    Supabase Cloud    │
│   (SwiftData/Room)   │  │    (PostgreSQL)      │
└─────────────────────┘  └─────────────────────┘
```

### 同步队列设计

每个本地写入操作生成一条 SyncRecord：

```swift
struct SyncRecord {
    var id: UUID
    var tableName: String        // "logs", "profiles", etc.
    var recordId: UUID          // 目标记录 ID
    var operation: SyncOp       // .insert, .update, .delete
    var payload: Data           // JSON payload
    var createdAt: Date
    var retryCount: Int
    var status: SyncStatus      // .pending, .syncing, .failed, .done
}
```

### 同步流程

```swift
class SyncEngine: ObservableObject {
    func syncPending() async {
        let pending = fetchPendingSyncRecords()
        for record in pending {
            do {
                switch record.tableName {
                case "logs":
                    try await syncLog(record)
                case "profiles":
                    try await syncProfile(record)
                // ...
                }
                markSynced(record.id)
            } catch {
                incrementRetry(record.id)
                if record.retryCount >= 5 {
                    markFailed(record.id)
                }
            }
        }
    }

    // Realtime subscription
    func subscribeToChanges() {
        channel = supabase.realtime.channel("user_changes")
        channel.onPostgresChange(.insert, table: "logs") { [weak self] event in
            self?.handleRemoteChange(event)
        }
        supabase.realtime.subscribe(channel)
    }
}
```

---

## 4. API Key 安全

### 配置文件 (.env 或 xcconfig)

```
SUPABASE_URL=https://wnsovtrfzgjgrsuwnkte.supabase.co
SUPABASE_ANON_KEY=sb_publishable_wmD46P2xe2E4RsFshIuksw_-VGtymEH
```

⚠️ **只使用 anon key**（公开 key），RLS 策略已保护数据安全。
**不要在客户端代码中硬编码 service_role key**。

### iOS: Info.plist 或 xcconfig

```bash
# Config.xcconfig
SUPABASE_URL = https://xxx.supabase.co
SUPABASE_ANON_KEY = eyJ...
```

### Android: local.properties → BuildConfig

```kotlin
// build.gradle.kts
android {
    buildFeatures {
        buildConfig = true
    }
}

// BuildConfig 自动生成
// BuildConfig.SUPABASE_URL
// BuildConfig.SUPABASE_ANON_KEY
```

---

## 5. 推送通知配置

### iOS

1. Apple Developer → Certificates → APNs Key
2. Supabase Dashboard → Settings → Push Notifications → 上传 APNs Key
3. Xcode → Signing & Capabilities → + Push Notifications
4. Xcode → Signing & Capabilities → + Background Modes → Remote notifications

### Android

1. Firebase Console → 创建项目 → 下载 google-services.json
2. Supabase Dashboard → Settings → Push Notifications → 配置 FCM
3. AndroidManifest.xml 添加通知权限

---

## 6. 环境变量清单

| 变量 | 示例 | 说明 |
|------|------|------|
| `SUPABASE_URL` | `https://wnsovtrfzgjgrsuwnkte.supabase.co` | 项目 URL |
| `SUPABASE_ANON_KEY` | `sb_publishable_...` | 匿名公钥（RLS 保护） |
| `SUPABASE_SERVICE_ROLE_KEY` | `eyJ...` | 仅服务端使用，不入客户端 |
