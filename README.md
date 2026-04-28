# LifeQuest — 人生努力可视化

> 把日常生活变成一场 RPG。记录每一次努力，见证自己的成长。

```
┌─────────────────┐     ┌─────────────────┐     ┌──────────────┐
│  iOS (SwiftUI)  │     │ Android (Compose)│     │   Web (v1)   │
│  原生客户端      │     │ 原生客户端        │     │  单文件归档   │
└────────┬────────┘     └────────┬─────────┘     └──────────────┘
         │                       │
         └───────────┬───────────┘
                     │
              ┌──────▼──────┐
              │   Supabase   │
              │  PostgreSQL  │
              │  Auth + RLS  │
              └──────────────┘
```

## ✨ 功能

| 模块 | 说明 |
|------|------|
| 🧙 **角色系统** | 自定义昵称头像，25 级 + 11 阶称号，经验值驱动升级 |
| ⏱️ **专注计时器** | 实时计时，6 类别选择，精确到分钟 |
| 🗡️ **技能等级** | 学习/科研/编程/运动/阅读/表达，独立经验与升级 |
| 📊 **数据分析** | 周统计 + 趋势图 + 分类分布 + 热力图 |
| 🏆 **成就系统** | 24 成就，4 级稀有度（普通/稀有/史诗/传说） |
| 🎆 **升级特效** | 光环扩散 + 数字弹跳 + 彩纸雨 |
| ☁️ **云端同步** | 匿名登录即用，可选注册升级，离线支持 |
| 📤 **数据迁移** | Web v1 JSON 一键导入，跨平台无缝衔接 |

## 项目结构

```
life-xp/
├── shared/                          # 共享设计规范（双端统一标准）
│   ├── design/DESIGN_SYSTEM.md      # 色彩/字体/间距/圆角/动画/组件
│   └── docs/
│       ├── DATA_MODELS.md           # 三端统一数据模型
│       └── AUTH_SYNC_GUIDE.md       # Auth + 离线同步引擎
│
├── supabase/                        # 后端
│   └── migrations/
│       └── 001_initial_schema.sql   # 5 表 + RLS + 触发器 + 迁移函数
│
├── ios/LifeQuest/                   # iOS (SwiftUI)
│   ├── project.yml                  # XcodeGen 配置
│   └── LifeQuest/
│       ├── App/                     # 入口 + LaunchScreen
│       ├── Models/                  # LevelSystem / Category / Achievement
│       ├── ViewModels/              # AuthViewModel（匿名登录/注册升级）
│       ├── Views/                   # 5 Tab 页面 + 引导流程
│       ├── Services/                # SupabaseManager
│       └── Theme/                   # AppTheme（色彩/渐变/稀有度）
│
├── android/LifeQuest/               # Android (Jetpack Compose)
│   └── app/src/main/java/com/lifequest/
│       ├── data/model/              # 数据模型
│       ├── data/local/              # Room 实体 + SyncRecord
│       ├── ui/theme/                # Material3 暗色主题
│       ├── ui/navigation/           # NavHost + BottomBar
│       └── ui/                      # 各 Screen + ViewModel
│
└── web/index.html                   # v1 单文件归档（纯 HTML/CSS/JS）
```

## 快速开始

### 前置：Supabase

1. [创建项目](https://supabase.com/dashboard)
2. SQL Editor → 运行 `supabase/migrations/001_initial_schema.sql`
3. Authentication → Providers → 启用 **Anonymous** + **Email**

### iOS

```bash
cd ios/LifeQuest
xcodegen generate        # 生成 .xcodeproj
open LifeQuest.xcodeproj # Xcode 打开
# SPM 添加: https://github.com/supabase/supabase-swift
# ⌘R 运行
```

> 需要 Xcode 16+，iOS 17.0+

### Android

```bash
cd android/LifeQuest
# Android Studio 打开
# Gradle Sync → Run
```

> 需要 Android Studio，minSdk 26，targetSdk 35

### Web (v1)

直接打开 `web/index.html`，纯前端，无需部署。

## 技术栈

| | iOS | Android |
|--|-----|---------|
| 语言 | Swift 5.9 | Kotlin |
| UI | SwiftUI | Jetpack Compose |
| 架构 | MVVM | MVVM + Hilt |
| 本地存储 | SwiftData | Room |
| 网络 | supabase-swift | supabase-kotlin |
| 图表 | Swift Charts | Vico |
| 动画 | SwiftUI + Lottie | Compose + Lottie |

## 数据库设计

| 表 | 说明 |
|----|------|
| `profiles` | 用户档案（自动关联 auth.users） |
| `logs` | 活动记录（分类/时长/经验/日期） |
| `custom_categories` | 自定义类别 |
| `unlocked_achievements` | 成就解锁记录 |
| `timer_snapshots` | 进行中的计时器快照 |

所有表均启用 RLS，用户只能访问自己的数据。

## 用户体系

```
首次打开 → 匿名登录（自动）→ 立即使用
   │
   └── 随时可升级为邮箱/手机号注册（数据保留）
```

## License

MIT
