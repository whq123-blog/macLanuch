# macLanuch - macOS 启动台完美复刻

<div align="center">

![macLanuch Icon](icon.jpg)

**一比一复刻 macOS 启动台（Launchpad）**

提供与原生系统完全一致的功能和体验

[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![Platform](https://img.shields.io/badge/platform-macOS%2014.0%2B-lightgrey.svg)](https://www.apple.com/macos)
[![Swift](https://img.shields.io/badge/Swift-5.9-orange.svg)](https://swift.org)

</div>

---

## 📥 下载安装

### 从 GitHub Releases 下载（推荐）

**最新版本：v1.0.0**

👉 **[点击下载 macLanuch.dmg](https://github.com/whq123-blog/macLanuch/releases/latest)**

或者访问 Releases 页面：
```
https://github.com/whq123-blog/macLanuch/releases
```

### 安装步骤

1. **下载 DMG 文件**
   - 点击上面的下载链接
   - 或从 Releases 页面下载最新版本

2. **打开并安装**
   ```
   双击 macLanuch.dmg 打开
   将 macLanuch.app 拖到 Applications 文件夹
   ```

3. **首次运行（重要！）**
   ```
   右键点击应用 → 选择"打开"
   点击弹出的"打开"按钮
   以后就可以正常双击运行了
   ```

> ⚠️ 由于应用未签名，首次运行需要右键打开。详细说明请查看 [INSTALL.md](INSTALL.md)

---

## ✨ 功能特性

### 基础功能
- ✅ 自动扫描系统所有应用
- ✅ 网格布局显示（7×5，可自定义）
- ✅ 分页浏览（左右滑动）
- ✅ 实时搜索过滤
- ✅ 点击启动应用
- ✅ 背景模糊效果
- ✅ 流畅的打开/关闭动画

### 高级功能
- ✅ **编辑模式** - 图标抖动动画，拖拽重新排列
- ✅ **文件夹管理** - 创建、查看、解散文件夹
- ✅ **应用删除** - 非系统应用可卸载
- ✅ **数据持久化** - 保存用户布局配置
- ✅ **设置界面** - 自定义快捷键、布局参数
- ✅ **全局快捷键** - 默认 Cmd+Space 快速唤起

### 触发方式
- 🖱️ 点击菜单栏图标
- 🖱️ 点击 Dock 图标（可配置）
- ⌨️ 全局快捷键（Cmd+Space，可自定义）

---

## 📖 使用指南

### 基本操作

#### 浏览应用
- 应用以网格形式显示（默认 7×5）
- 左右滑动或点击底部圆点切换页面

#### 搜索应用
- 在顶部搜索栏输入应用名称
- 实时显示匹配结果
- 清空搜索恢复分页视图

#### 启动应用
- 点击应用图标即可启动
- 启动台会自动关闭

#### 编辑模式
- 点击搜索栏右侧的齿轮图标进入编辑模式
- 图标开始抖动
- 拖拽应用重新排列
- 点击 X 按钮删除应用（仅非系统应用）
- 点击完成按钮（✓）退出

#### 文件夹功能
- 在编辑模式下，拖拽一个应用到另一个应用上
- 自动创建文件夹
- 点击文件夹图标展开查看
- 从文件夹拖出应用可解散文件夹

### 关闭启动台
- 按 **Esc** 键
- 点击背景空白区域
- 再次点击菜单栏图标
- 按 **Cmd + Space**（如果启用了快捷键）

详细使用说明请查看 [INSTALL.md](INSTALL.md)

---

## 💻 系统要求

- **操作系统**: macOS 14.0 (Sonoma) 或更高版本
- **处理器**: Apple Silicon (M1/M2/M3) 或 Intel Mac
- **存储空间**: 约 10MB

---

## 🔧 从源码构建

### 前提条件
- Xcode 15.0 或更高版本
- macOS 14.0 SDK

### 构建步骤

1. **克隆仓库**
   ```bash
   git clone https://github.com/whq123-blog/macLanuch.git
   cd macLanuch
   ```

2. **在 Xcode 中创建项目**
   - 打开 Xcode
   - File → New → Project
   - 选择 **macOS → App**
   - Product Name: `macLanuch`
   - Interface: **SwiftUI**
   - Language: **Swift**

3. **导入源代码**
   - 删除默认的 `ContentView.swift`
   - 将 `macLanuch/` 目录下的所有文件拖入项目
   - 确保勾选 "Create groups" 和正确的 target

4. **配置权限**
   - Signing & Capabilities → 添加 **Hardened Runtime**
   - 勾选 **Apple Events**

5. **构建运行**
   ```
   Product → Clean Build Folder (Cmd + Shift + K)
   Product → Build (Cmd + B)
   Product → Run (Cmd + R)
   ```

详细构建说明请查看 [QUICKSTART.md](QUICKSTART.md)

---

## 📂 项目结构

```
macLanuch/
├── App/                    # 应用入口
│   ├── macLanuchApp.swift
│   └── AppDelegate.swift
├── Models/                 # 数据模型
│   ├── AppInfo.swift
│   ├── Folder.swift
│   ├── Page.swift
│   └── LayoutConfig.swift
├── ViewModels/            # 视图模型
│   ├── LaunchpadViewModel.swift
│   └── SettingsViewModel.swift
├── Views/                 # UI 视图
│   ├── Main/
│   └── Components/
├── Services/              # 核心服务
│   ├── AppScannerService.swift
│   ├── AppLaunchService.swift
│   ├── WindowManagerService.swift
│   ├── GlobalShortcutService.swift
│   └── PersistenceService.swift
└── Utilities/             # 工具类
    ├── Constants.swift
    └── IconCache.swift
```

---

## 🛠 技术栈

- **语言**: Swift 5.9
- **UI 框架**: SwiftUI + AppKit
- **平台**: macOS 14+ (Sonoma)
- **架构**: MVVM (Model-ViewModel-View-Service)

**无第三方依赖** - 纯原生实现

---

## 📊 项目统计

- **Swift 文件**: 28 个
- **代码行数**: ~2500+ 行
- **架构层次**: 6 层
- **DMG 大小**: 2.8 MB

---

## 🐛 已知问题

### 应用签名
- 应用未签名，首次运行需要右键打开
- 不影响正常使用，这是开源应用的常见情况

### 快捷键冲突
- 默认 Cmd+Space 可能与 Spotlight 冲突
- 可在设置中自定义快捷键

---

## 🗺 路线图

### v1.0.0 (当前)
- ✅ 完整的启动台功能
- ✅ 编辑模式和拖拽排列
- ✅ 文件夹管理
- ✅ 数据持久化
- ✅ 设置界面

### v1.1.0 (计划)
- 🔲 代码签名和公证
- 🔲 多显示器支持
- 🔲 键盘导航优化
- 🔲 应用分组标签

### v2.0.0 (未来)
- 🔲 小组件支持
- 🔲 应用使用统计
- 🔲 智能应用推荐

---

## 📝 文档

- [安装指南](INSTALL.md) - 详细的安装和使用说明
- [快速开始](QUICKSTART.md) - 5 分钟快速上手
- [编译检查清单](COMPILE_CHECKLIST.md) - 编译前检查

---

## 🤝 贡献

欢迎提交 Issue 和 Pull Request！

### 如何贡献
1. Fork 本仓库
2. 创建功能分支 (`git checkout -b feature/AmazingFeature`)
3. 提交更改 (`git commit -m 'Add some AmazingFeature'`)
4. 推送到分支 (`git push origin feature/AmazingFeature`)
5. 创建 Pull Request

---

## 👨‍💻 作者

**cold.wang**
- GitHub: [@whq123-blog](https://github.com/whq123-blog)
- Project: [macLanuch](https://github.com/whq123-blog/macLanuch)

---

## 📄 许可证

本项目采用 MIT 许可证 - 查看 [LICENSE](LICENSE) 文件了解详情

---

## 🙏 致谢

感谢所有为这个项目做出贡献的人！

如果这个项目对你有帮助，请给一个 ⭐️ Star！

---

## 📮 联系方式

如有问题或建议，欢迎：
- 提交 [Issue](https://github.com/whq123-blog/macLanuch/issues)
- 查看 [Wiki](https://github.com/whq123-blog/macLanuch/wiki)

---

<div align="center">

**Made with ❤️ by cold.wang**

</div>