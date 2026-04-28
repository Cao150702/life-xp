# LifeQuest 设计规范 (Design System)

> 双端（iOS SwiftUI / Android Jetpack Compose）统一设计标准

---

## 1. 色彩系统

### 暗色主题（默认）

| Token | 色值 | 用途 |
|-------|------|------|
| `bg` | `#07090F` | 主背景 |
| `bg2` | `#0C1018` | 次级背景 |
| `card` | `#111622` | 卡片背景 |
| `card2` | `#161D2E` | 弹窗/悬停卡片 |
| `card3` | `#1A2236` | 高亮卡片 |
| `border` | `#1E2A42` | 分隔线/边框 |
| `border2` | `#263352` | 强调边框 |
| `text` | `#E8ECF4` | 主文字 |
| `text2` | `#A0AEC0` | 次级文字 |
| `muted` | `#5A6A85` | 弱文字/提示 |

### 品牌色

| Token | 色值 | 用途 |
|-------|------|------|
| `purple` | `#8B5CF6` | 主品牌色 |
| `purple2` | `#A78BFA` | 浅品牌色 |
| `blue` | `#3B82F6` | 辅助色 |
| `cyan` | `#06B6D4` | 科研/编程高亮 |
| `green` | `#10B981` | 运动/成功 |
| `emerald` | `#34D399` | 经验值/正向 |
| `orange` | `#F59E0B` | 阅读/警告 |
| `amber` | `#FBBF24` | 成就/金色 |
| `pink` | `#EC4899` | 表达/稀有 |
| `rose` | `#FB7185` | 危险/史诗 |
| `red` | `#EF4444` | 错误/删除 |

### 渐变

| 名称 | 定义 | 用途 |
|------|------|------|
| `brandGradient` | `purple → blue` | 主按钮、FAB、进度条 |
| `successGradient` | `emerald → green` | 计时器活跃态 |
| `goldGradient` | `amber → orange` | 成就卡片边框 |
| `heroGradient` | `purple2/cyan @ 15% opacity` | 角色卡背景光晕 |

### 成就稀有度色

| 稀有度 | 背景 | 文字 |
|--------|------|------|
| Common | `blue @ 15%` | `blue` |
| Rare | `purple @ 15%` | `purple` |
| Epic | `pink @ 15%` | `pink` |
| Legendary | `amber @ 15%` | `amber` |

---

## 2. 字体系统

### iOS

```swift
// 主字体
.font(.system(.body, design: .default))  // Inter 风格
// 数字/等宽
.font(.system(.title2, design: .monospaced))  // JetBrains Mono 风格
```

### Android

```kotlin
// 主字体 - 使用系统默认（接近 Inter）
Typography(
    bodyLarge = TextStyle(fontFamily = FontFamily.Default),
    // 数字用等宽
    displayMedium = TextStyle(fontFamily = FontFamily.Monospace)
)
```

### 字号层级

| 层级 | 大小 | 字重 | 用途 |
|------|------|------|------|
| Display | 48-64 | Black (900) | 等级数字 |
| H1 | 28-32 | ExtraBold (800) | 页面标题 |
| H2 | 20-24 | Bold (700) | 卡片标题/区域标题 |
| Body | 15-16 | Regular (400) | 正文内容 |
| Caption | 11-13 | SemiBold (600) | 标签/备注 |
| Micro | 9-10 | SemiBold (600) | 稀有度标签 |

---

## 3. 圆角 & 阴影

| Token | iOS `CornerRadius` | Android `dp` | 用途 |
|-------|-------------------|-------------|------|
| `radius` | 14 | 14dp | 小卡片 |
| `radiusLg` | 20 | 20dp | 大卡片/设置组 |
| `radiusXl` | 28 | 28dp | 弹窗/底部面板 |
| `radiusFull` | ∞ | 9999dp | 头像/药丸按钮 |

### 阴影

```swift
// iOS
.shadow(color: .black.opacity(0.4), radius: 12, x: 0, y: 6)
.shadow(color: .black.opacity(0.6), radius: 24, x: 0, y: 12)  // Large
```

```kotlin
// Android
fun Modifier.cardShadow() = this.shadow(
    elevation = 12.dp,
    shape = RoundedCornerShape(14.dp),
    ambientColor = Color.Black.copy(alpha = 0.4f),
    spotColor = Color.Black.copy(alpha = 0.4f)
)
```

---

## 4. 间距系统

基础单位: 4px

| Token | 值 | 用途 |
|-------|------|------|
| `xs` | 4 | 图标间距 |
| `sm` | 8 | 元素内间距 |
| `md` | 12 | 卡片内间距/网格间距 |
| `lg` | 16 | 页面内边距 |
| `xl` | 20 | 区块间距 |
| `2xl` | 24 | 大区块间距 |
| `3xl` | 32 | 页面顶级间距 |

---

## 5. 类别配色

每个类别有固定颜色，贯穿图标、进度条、技能卡：

| ID | 名称 | 图标 | 颜色 | XP/分钟 |
|----|------|------|------|---------|
| `study` | 学习 | 📚 | `#8B5CF6` | 3 |
| `research` | 科研 | 🔬 | `#3B82F6` | 4 |
| `code` | 编程 | 💻 | `#06B6D4` | 4 |
| `sport` | 运动 | 🏃 | `#10B981` | 2 |
| `read` | 阅读 | 📖 | `#F59E0B` | 2 |
| `express` | 表达 | 🎤 | `#EC4899` | 3 |

---

## 6. 动画规范

### 标准动画

| 名称 | iOS | Android | 时长 |
|------|-----|---------|------|
| fadeIn | `.opacity + .offset(y: 12)` | `fadeIn + slideInVertically(12dp)` | 0.3s ease |
| scaleIn | `.scaleEffect(0.92)` | `scaleIn(0.92f)` | 0.3s ease |
| slideUp | `.offset(y: 40)` | `slideInVertically(40dp)` | 0.4s ease |
| pulse | `.opacity(pulse)` | `alpha pulse` | 2s infinite |

### 交互反馈

- **按钮点击**: scale 0.95 → 1.0，0.15s
- **卡片悬停/点击**: translateY -3px + shadow 增强
- **经验值获得**: 数字 pop 动画 (1.0 → 1.3 → 1.0)
- **等级提升**: 全屏 overlay + confetti 粒子
- **成就解锁**: Toast + confetti

### Haptics（iOS）

```swift
UIImpactFeedbackGenerator(style: .medium).impactOccurred()  // 按钮点击
UINotificationFeedbackGenerator().notificationOccurred(.success)  // 成就解锁
```

---

## 7. 组件规范

### FAB（浮动操作按钮）

- 位置: 右下角 (bottom: 24, trailing: 24)
- 大小: 56x56
- 背景: brandGradient
- 图标: "+" (24px)
- 计时器活跃态: successGradient + breathe 动画

### 技能卡片

- 圆角: 14px
- 顶部 2px 色条（类别色）
- 内容: 图标(40px 圆) + 名称 + Lv + 进度条 + XP 数值

### 成就卡片

- 圆角: 14px
- 右上角稀有度标签
- 未解锁: opacity 0.5 + grayscale 60%
- 已解锁: 金色边框 + 渐变背景

### Toast

- 右上角弹出
- 左侧 3px 色条区分类型 (XP=emerald, Level=amber, Achievement=pink, Warning=red)
- 3.5s 后滑出消失

---

## 8. 数据展示格式

| 数据 | 格式 | 示例 |
|------|------|------|
| XP | `>=10000` → `1.0w`, `>=1000` → `1.0k` | 15000 → 1.5w |
| 时长 | `X分钟` | 120 → 120分钟 |
| 连续天数 | 数字直接显示 | 7 |
| 日期 | `M/D` (本周), `YYYY-MM-DD` (详情) | 4/28 |
| 时间 | `HH:MM` | 14:30 |
