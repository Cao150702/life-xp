# LifeQuest — iOS/Android 双原生客户端

> 完整项目说明见 [根目录 README](../../README.md)

## iOS (SwiftUI)

```
ios/LifeQuest/
├── project.yml              # XcodeGen 配置（生成 .xcodeproj）
└── LifeQuest/
    ├── LifeQuest.swift       # App 入口
    ├── Info.plist
    ├── Assets.xcassets/
    ├── Models/Models.swift   # LevelSystem / Category / Achievement
    ├── ViewModels/AuthViewModel.swift
    ├── Services/SupabaseManager.swift
    ├── Theme/AppTheme.swift
    └── Views/                # MainTabView / Onboarding / Home / Analytics / Achievements / Settings
```

### 运行

```bash
# 需要先安装 xcodegen: brew install xcodegen
cd ios/LifeQuest
xcodegen generate
open LifeQuest.xcodeproj
```

SPM 添加依赖: `https://github.com/supabase/supabase-swift`

## Android (Jetpack Compose)

```
android/LifeQuest/app/src/main/java/com/lifequest/
├── LifeQuestApp.kt           # Hilt Application
├── data/model/Models.kt
├── data/local/Entities.kt    # Room 实体
├── ui/theme/                 # Color / Theme / Type
├── ui/navigation/            # NavHost + BottomBar
└── ui/                       # 各页面 Screen + OnboardingViewModel
```

### 运行

用 Android Studio 打开 `android/LifeQuest/`，Gradle Sync 后 Run。
