# macLanuch - macOS 启动台复刻

一比一复刻 macOS 启动台（Launchpad），提供与原生系统完全一致的功能和体验。

## 项目状态

✅ **基础版本已完成**

当前已实现的功能：
- 应用扫描和网格显示
- 分页切换（左右滑动）
- 搜索过滤功能
- 点击启动应用
- 背景模糊效果
- 打开/关闭动画

待实现的高级功能：
- 编辑模式（拖拽排列）
- 文件夹功能
- 全局快捷键
- 拖拽重新排列
- 数据持久化

## 如何在 Xcode 中使用此项目

由于这是一个 macOS SwiftUI 应用，需要使用 Xcode 来构建。请按以下步骤操作：

### 步骤 1: 创建 Xcode 项目

1. 打开 Xcode
2. 选择 **File > New > Project**
3. 选择 **macOS > App**
4. 点击 **Next**
5. 配置项目：
   - **Product Name**: `macLanuch`
   - **Team**: 选择你的开发团队
   - **Organization Identifier**: `com.macLaunch`
   - **Bundle Identifier**: `com.macLaunch.macLanuch`
   - **Interface**: **SwiftUI**
   - **Language**: **Swift**
   - **Storage**: None (不需要 Core Data)
6. 点击 **Next**，选择项目保存位置（建议选择 `/Users/cold.wang/cold/macLanuch` 目录）
7. 点击 **Create**

### 步骤 2: 导入源代码文件

1. 在 Xcode 左侧的项目导航器中，删除默认生成的 `ContentView.swift` 文件
2. 在 Finder 中，将以下目录中的所有文件拖到 Xcode 项目中：
   - `macLanuch/App/` → 应用入口文件
   - `macLanuch/Models/` → 数据模型
   - `macLanuch/ViewModels/` → 视图模型
   - `macLanuch/Views/` → UI 视图
   - `macLanuch/Services/` → 核心服务
   - `macLanuch/Utilities/` → 工具类
3. 拖入时选择：
   - **Copy items if needed**
   - **Create groups**
   - **Add to targets: macLanuch**

### 步骤 3: 配置 Info.plist

在项目的 **Info** 标签页中，添加以下配置：

1. **Application Category**: `public.app-category.utilities`
2. 添加自定义键值（可选）：
   - `NSAppleEventsUsageDescription`: "macLaunch needs permission to launch applications"

或者手动编辑 `Info.plist` 文件：

```xml
<key>NSAppleEventsUsageDescription</key>
<string>macLaunch needs permission to launch applications.</string>
<key>LSUIElement</key>
<false/>
```

### 步骤 4: 配置 Entitlements

1. 在项目导航器中，选择项目文件（最顶层）
2. 选择 **Signing & Capabilities** 标签
3. 点击 **+ Capability**
4. 添加 **Hardened Runtime**
5. 配置 entitlements：
   - 勾选 **Apple Events**（用于启动其他应用）

创建 `macLanuch.entitlements` 文件：

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>com.apple.security.app-sandbox</key>
    <false/>
    <key>com.apple.security.automation.apple-events</key>
    <true/>
</dict>
</plist>
```

### 步骤 5: 构建和运行

1. 选择 **My Mac** 作为运行目标
2. 点击 Xcode 左上角的 **Run** 按钮（或按 `Cmd+R`）
3. 应用应该会启动，并在菜单栏显示一个图标
4. 点击菜单栏图标可以打开启动台

## 使用方法

### 打开启动台

- **方式 1**: 点击菜单栏的网格图标
- **方式 2**: 点击 Dock 图标（如果显示）
- **方式 3**: 按快捷键（稍后实现全局快捷键功能）

### 搜索应用

- 在启动台顶部搜索栏输入应用名称
- 匹配的应用会实时显示
- 清空搜索框恢复分页视图

### 分页浏览

- 左右滑动（或拖动）切换页面
- 点击底部的页面指示器（小圆点）快速跳转

### 启动应用

- 点击应用图标即可启动应用
- 启动台会自动关闭

### 关闭启动台

- 按 `Esc` 键
- 点击背景模糊区域
- 再次点击菜单栏图标
- 启动应用后自动关闭

## 项目结构

```
macLanuch/
├── App/                           # 应用入口
│   ├── macLanuchApp.swift          # SwiftUI App 入口
│   └── AppDelegate.swift           # App 生命周期管理
│
├── Models/                         # 数据模型
│   ├── AppInfo.swift               # 应用信息模型
│   ├── Folder.swift                # 文件夹模型
│   ├── Page.swift                  # 页面模型
│   ├── LayoutConfig.swift          # 布局配置
│   └── AppPosition.swift           # 应用位置配置
│
├── ViewModels/                     # 视图模型
│   └── LaunchpadViewModel.swift    # 主视图模型
│
├── Views/                          # UI 视图
│   ├── Main/
│   │   ├── LaunchpadView.swift     # 主启动台视图
│   │   └── BackgroundBlurView.swift # 背景模糊视图
│   └── Components/
│       ├── AppIconView.swift       # 应用图标视图
│       ├── AppGridView.swift       # 应用网格视图
│       ├── SearchBarView.swift     # 搜索栏视图
│       ├── PageIndicatorView.swift # 页面指示器
│       └ DeleteBadgeView.swift    # 删除徽章视图
│
├── Services/                       # 核心服务
│   ├── AppScannerService.swift     # 应用扫描服务
│   ├── AppLaunchService.swift      # 应用启动服务
│   ├── WindowManagerService.swift  # 窗口管理服务
│   └ PersistenceService.swift     # 数据持久化服务
│
└── Utilities/                      # 工具类
    ├── Constants.swift             # 常量定义
    └ IconCache.swift               # 图标缓存
```

## 核心功能详解

### 1. 应用扫描

- 自动扫描系统所有已安装应用
- 支持扫描的目录：
  - `/Applications`
  - `/System/Applications`
  - `/System/Applications/Utilities`
  - `/Applications/Utilities`
  - `~/Applications`（用户应用目录）
- 解析每个 `.app` bundle 的 `Info.plist` 获取应用信息
- 加载高质量应用图标（支持缓存）

### 2. 网格布局

- 默认布局：7 列 × 5 行（每页最多 35 个应用）
- 应用图标大小：80×80 像素
- 图标间距：20 像素
- 自动分页显示大量应用

### 3. 分页导航

- 使用 `TabView` 实现左右滑动切换
- 底部显示页面指示器（小圆点）
- 支持点击指示器快速跳转页面

### 4. 搜索功能

- 实时搜索过滤
- 支持应用名称模糊匹配
- 搜索结果单独显示（不分页）
- 清空搜索恢复分页视图

### 5. 窗口管理

- 全屏 borderless 窗口
- 窗口层级：`.screenSaver`（覆盖 Dock 和菜单栏）
- 背景模糊效果（`NSVisualEffectView`）
- 打开/关闭动画（缩放 + 透明度）

### 6. 应用启动

- 使用 `NSWorkspace.openApplication` API
- 支持激活正在运行的应用
- 支持卸载应用（移到废纸篓，仅非系统应用）

## 已知问题和待实现功能

### 待实现功能

1. **编辑模式**
   - 长按进入编辑模式
   - 应用图标抖动动画
   - 拖拽重新排列位置
   - 删除/卸载应用（显示 X 按钮）

2. **文件夹功能**
   - 拖拽应用到另一个应用上创建文件夹
   - 文件夹图标显示前 4 个应用
   - 点击文件夹展开显示内部应用
   - 从文件夹拖出应用解散文件夹

3. **全局快捷键**
   - 注册 `Cmd+Space` 快捷键
   - 支持自定义快捷键
   - 检测快捷键冲突

4. **数据持久化**
   - 保存用户的应用排列配置
   - 保存文件夹配置
   - 下次启动恢复上次布局

5. **设置界面**
   - 自定义快捷键
   - 布局参数调整（列数、行数）
   - 显示/隐藏系统应用选项

6. **性能优化**
   - 图标缓存优化
   - 异步加载优化
   - 大量应用时的流畅性

### 已知问题

- 当前版本使用 Xcode 创建项目，SPM 编译可能有问题
- 编辑模式和文件夹功能尚未实现
- 全局快捷键功能尚未实现
- 用户布局配置持久化逻辑需要完善

## 技术栈

- **语言**: Swift 5.9
- **UI 框架**: SwiftUI + AppKit
- **平台**: macOS 14+ (Sonoma)
- **架构**: MVVM (Model-ViewModel-View-Service)

## 依赖库

当前版本不依赖任何第三方库。

计划添加的依赖：
- `KeyboardShortcuts` - 用于全局快捷键管理（可选）

## 许可证

MIT License

## 作者

Created by Claude Code

## 更新日志

### v0.1.0 (当前版本)

- ✅ 基础项目结构
- ✅ 应用扫描功能
- ✅ 网格布局显示
- ✅ 分页导航
- ✅ 搜索过滤
- ✅ 应用启动
- ✅ 背景模糊效果
- ✅ 打开/关闭动画

### v0.2.0 (计划)

- 🔲 编辑模式
- 🔲 拖拽排列
- 🔲 文件夹功能
- 🔲 全局快捷键

### v1.0.0 (目标)

- 🔲 完整功能实现
- 🔲 性能优化
- 🔲 设置界面
- 🔲 用户布局持久化
- 🔲 完整测试

## 下一步开发计划

根据项目计划，接下来需要实现：

1. **Phase 4: 高级功能**
   - 编辑模式和抖动动画
   - 拖拽重新排列
   - 文件夹创建和管理

2. **Phase 5: 触发和持久化**
   - 全局快捷键服务
   - 数据持久化完善
   - 设置界面

3. **Phase 6: 测试和优化**
   - 功能测试
   - 性能优化
   - Bug 修复

预计完整版本开发时间：10-15 天

## 贡献

欢迎提交 Issue 和 Pull Request！

## 支持

如有问题，请提交 Issue 或参考项目计划文档：`/Users/cold.wang/.claude/plans/fancy-honking-scroll.md`