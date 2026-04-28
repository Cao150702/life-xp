# LifeQuest — 全平台人生努力可视化

> Swift (iOS) + Kotlin (Android) + Web，双原生极致体验

```
┌─────────────────┐     ┌─────────────────┐     ┌──────────────┐
│  iOS (SwiftUI)  │     │ Android (Compose)│     │   Web (保留)  │
│  Xcode 项目      │     │ Android Studio   │     │  现有单文件   │
└────────┬────────┘     └────────┬─────────┘     └──────────────┘
         │                       │
         └───────────┬───────────┘
                     │
              ┌──────▼──────┐
              │   Supabase   │
              │  PostgreSQL  │
              │  Auth + RT   │
              └──────────────┘
```

## 项目结构

```
life-xp/
├── shared/                     # 共享资源（双端统一标准）
│   ├── design/
│   │   └── DESIGN_SYSTEM.md   # 色彩/字体/间距/圆角/动画/组件规范
│   └── docs/
│       ├── DATA_MODELS.md     # 数据库 Schema + Swift/Kotlin 实体定义
│       └── AUTH_SYNC_GUIDE.md # Auth 配置 + 同步引擎设计
│
├── supabase/                   # Supabase 后端
│   └── migrations/
│       └── 001_initial_schema.sql  # 完整建库脚本（建表+RLS+触发器+函数）
│
├── ios/LifeQuest/             # iOS SwiftUI 客户端
│   ├── LifeQuest.swift         # App 入口
│   ├── Models/                 # 数据模型（LevelSystem/Achievement/Category）
│   ├── ViewModels/             # AuthViewModel
│   ├── Views/                  # 5 个核心页面 + 引导流程
│   ├── Services/               # SupabaseManager
│   └── Theme/                  # AppTheme（Color/Gradient/Spacing/Rarity）
│
├── android/LifeQuest/         # Android Compose 客户端
│   └── app/src/main/java/com/lifequest/
│       ├── data/model/         # 数据模型
│       ├── data/local/         # Room 实体 + SyncRecord
│       ├── ui/theme/           # Color/Theme/Type
│       ├── ui/navigation/      # NavHost + BottomBar
│       └── ui/                 # 各页面 Screen
│
└── web/                        # Web 端（保留现有单文件）
```

## 快速开始

### 1. Supabase 后端

1. 创建 [Supabase](https://supabase.com) 项目
2. 在 SQL Editor 中运行 `supabase/migrations/001_initial_schema.sql`
3. Authentication → Providers → 启用 Anonymous + Email
4. 记录 Project URL 和 Anon Key

### 2. iOS

```bash
cd ios/LifeQuest
# 用 Xcode 打开，配置 SupabaseManager.swift 中的 URL 和 Key
# Swift Package Manager 添加: https://github.com/supabase/supabase-swift
# Cmd+R 运行
```

### 3. Android

```bash
cd android/LifeQuest
# 用 Android Studio 打开
# 修改 app/build.gradle.kts 中的 SUPABASE_URL 和 SUPABASE_ANON_KEY
# Gradle Sync → Run
```

### 4. Web

直接打开 `docs/life-xp/index.html`，无需部署。

## 用户体系

- **匿名优先**：首次打开自动匿名登录，可立即使用
- **可选注册**：随时升级为邮箱/手机号账号
- **数据迁移**：Web 版导出 JSON → App 端一键导入

## 技术栈

| 层面 | iOS | Android |
|------|-----|---------|
| 语言 | Swift 5.9 | Kotlin |
| 框架 | SwiftUI | Jetpack Compose |
| 架构 | MVVM | MVVM + Hilt |
| 本地存储 | SwiftData | Room |
| 网络 | supabase-swift | supabase-kotlin |
| 图表 | Swift Charts | Vico |
| 动画 | SwiftUI + Lottie | Compose + Lottie |

## License

MIT
