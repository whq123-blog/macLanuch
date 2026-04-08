# 快速开始指南

## 5 分钟快速上手 macLanuch

### 第 1 步：在 Xcode 中创建项目 (2 分钟)

1. 打开 Xcode
2. `File` → `New` → `Project`
3. 选择 **macOS** → **App**
4. 配置项目信息：
   - Product Name: `macLanuch`
   - Bundle Identifier: `com.macLaunch.macLanuch`
   - Interface: **SwiftUI**
   - Language: **Swift**
5. 保存到 `/Users/cold.wang/cold/macLanuch`

### 第 2 步：导入源代码 (2 分钟)

1. 在 Finder 中打开 `/Users/cold.wang/cold/macLanuch/macLanuch` 目录
2. 将以下文件夹拖入 Xcode 项目：
   - `App/`
   - `Models/`
   - `ViewModels/`
   - `Views/`
   - `Services/`
   - `Utilities/`
3. 确保勾选 **Copy items if needed** 和 **Create groups**

### 第 3 步：配置权限 (1 分钟)

1. 在项目导航器中选择项目文件
2. 进入 **Signing & Capabilities** 标签
3. 添加 **Hardened Runtime**
4. 勾选 **Apple Events**

### 第 4 步：运行应用 (点击 Run)

1. 选择运行目标为 **My Mac**
2. 点击 `Cmd+R` 或 Run 按钮
3. 应用启动后会在菜单栏显示图标
4. 点击图标即可打开启动台！

## 基础使用

### 打开启动台

- 点击菜单栏的网格图标
- 按 `Cmd+Space`（需要先授权快捷键）
- 点击 Dock 图标（如果配置为显示）

### 功能列表

✅ **已实现的功能：**
- 自动扫描所有系统应用
- 网格布局显示（7×5）
- 分页浏览（左右滑动）
- 搜索过滤（实时搜索）
- 点击启动应用
- 文件夹显示（可以查看）
- 背景模糊效果
- 打开/关闭动画

🔲 **待完善的功能：**
- 编辑模式（拖拽排列）
- 文件夹创建（拖拽应用合并）
- 应用删除功能
- 用户布局持久化
- 设置界面

## 下一步

1. **测试基础功能**：尝试搜索、分页切换、启动应用
2. **反馈问题**：如遇到 Bug，请查看 README.md 提交反馈
3. **参与开发**：高级功能正在开发中，欢迎贡献代码

## 常见问题

### Q: 编译失败怎么办？

检查以下几点：
1. 确保所有文件都已正确导入
2. 确保 Target 设置正确（macLanuch）
3. 确保 macOS 版本设置为 14.0 或更高

### Q: 快捷键不工作？

需要授权：
1. 打开 **系统设置** → **隐私与安全性** → **辅助功能**
2. 添加 Xcode 或 macLanuch 应用
3. 重新运行应用

### Q: 找不到某些应用？

当前版本扫描以下目录：
- `/Applications`
- `/System/Applications`
- 用户应用目录

### Q: 如何隐藏 Dock 图标？

在 `AppDelegate.swift` 中修改：
```swift
NSApp.setActivationPolicy(.accessory)  // 不显示在 Dock
// 或
NSApp.setActivationPolicy(.regular)    // 显示在 Dock
```

## 获取帮助

- 详细文档：查看 `README.md`
- 实现计划：查看 `/Users/cold.wang/.claude/plans/fancy-honking-scroll.md`
- 问题反馈：提交 Issue

祝使用愉快！🎉