# LifeQuest iOS

SwiftUI + Supabase 双原生 iOS 客户端

## 开发环境

- Xcode 16+
- iOS 17.0+
- Swift 5.9+

## 项目结构

```
LifeQuest/
├── LifeQuest.swift              # App 入口
├── App/                         # App 级配置
├── Models/
│   └── Models.swift             # 数据模型、等级系统、成就、类别
├── ViewModels/
│   └── AuthViewModel.swift      # 认证状态管理
├── Views/
│   ├── MainTabView.swift        # 底部 Tab 导航
│   ├── Onboarding/
│   │   └── OnboardingView.swift # 引导流程（3步：欢迎/名字/角色）
│   ├── Home/
│   │   ├── HomeView.swift       # 首页（角色卡+统计+技能+记录）
│   │   ├── TimerView.swift      # 专注计时器
│   │   └── QuickLogView.swift   # 快速记录
│   ├── Analytics/
│   │   └── AnalyticsView.swift  # 数据分析（Charts）
│   ├── Achievements/
│   │   └── AchievementsView.swift
│   ├── Settings/
│   │   └── SettingsView.swift   # 设置（注册/导入导出/清空）
│   └── Components/
│       └── LaunchScreen.swift   # 启动页
├── Services/
│   └── SupabaseManager.swift    # Supabase 客户端配置
├── Theme/
│   └── AppTheme.swift           # 色彩/圆角/间距/Rarity 等设计 Token
└── Utils/
```

## 快速开始

### 1. 在 Xcode 中创建项目

```bash
# 方式一：手动创建
# File → New → Project → App
# Product Name: LifeQuest
# Interface: SwiftUI
# Language: Swift

# 方式二：直接使用本项目文件
# 将此目录拖入 Xcode
```

### 2. 配置 Supabase

编辑 `Services/SupabaseManager.swift`，替换：

```swift
static let supabaseURL = "https://YOUR_PROJECT.supabase.co"
static let supabaseAnonKey = "YOUR_ANON_KEY"
```

### 3. 安装依赖

使用 Swift Package Manager:

```
https://github.com/supabase/supabase-swift
```

依赖：
- `Supabase` (包含 Auth, Postgrest, Realtime, Storage)

### 4. 运行

```bash
# 在 Xcode 中: Cmd+R
# 或命令行:
xcodebuild -scheme LifeQuest -sdk iphonesimulator -destination 'platform=iOS Simulator,name=iPhone 16'
```

## 配色说明

所有颜色定义在 `Assets.xcassets/Colors/` 中，以 Color Set 形式存在：
- `bg`, `bg2`, `card`, `card2`, `card3` — 背景色阶
- `border`, `border2` — 边框色
- `text`, `text2`, `muted` — 文字色阶
- `purple`, `blue`, `cyan`, `green`, `emerald`, `orange`, `amber`, `pink`, `rose`, `red` — 品牌色

使用方式: `Color("purple")` 或 `Color.brandPurple`

## 下一步

- [ ] 接入 Supabase Auth 匿名登录
- [ ] 实现数据同步引擎
- [ ] 完善各页面真实数据绑定
- [ ] 添加推送通知
- [ ] 实现桌面小组件（WidgetKit）
- [ ] Haptic 反馈优化
- [ ] Lottie 动画（升级/成就）
