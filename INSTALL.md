# 📥 macLanuch 安装指南

## 系统要求

- **操作系统**: macOS 14.0 (Sonoma) 或更高版本
- **处理器**: Apple Silicon (M1/M2/M3) 或 Intel Mac
- **权限**: 需要管理员权限进行安装

---

## 下载安装

### 步骤 1：下载 DMG 文件

从以下位置下载最新版本：
- **GitHub Releases**: [https://github.com/whq123-blog/macLanuch/releases](https://github.com/whq123-blog/macLanuch/releases)
- 或直接获取 `macLanuch.dmg` 文件

### 步骤 2：打开 DMG

1. 找到下载的 `macLanuch.dmg` 文件
2. **双击打开** DMG 文件
3. 会弹出一个窗口，显示 `macLanuch.app` 图标

### 步骤 3：安装应用

**方法 1：拖拽安装（推荐）**
- 将 `macLanuch.app` 图标拖拽到 `Applications` 文件夹
- 等待复制完成

**方法 2：手动复制**
```bash
# 打开终端，运行：
cp -R /Volumes/macLanuch/macLanuch.app /Applications/
```

### 步骤 4：推出 DMG

- 右键点击桌面上的 `macLanuch` 磁盘图标
- 选择"推出"
- 或在 Finder 侧边栏点击推出按钮

---

## 首次运行（重要！）

由于应用未经过 Apple 公证，首次运行需要额外操作。

### ⚠️ 可能遇到的问题

**错误提示：**
```
"macLanuch" 无法打开，因为无法验证开发者。

macOS 无法验证此 App 不含恶意软件。
```

### ✅ 解决方案

#### 方法 1：右键打开（最简单，推荐）

1. 在 Finder 中找到 `macLanuch.app`
2. **右键点击** 应用图标（或按住 Control 点击）
3. 在菜单中选择 **"打开"**
4. 会弹出确认对话框：

   ![确认对话框](https://support.apple.com/library/content/dam/edam/applecare/images/en_US/macos/monterey/macos-monterey-system-preferences-security-privacy-general-open-anyway.png)

5. 点击 **"打开"** 按钮
6. 应用将正常启动
7. **以后就可以直接双击运行了**

#### 方法 2：系统设置允许

1. 尝试双击打开应用（会出现错误）
2. 打开 **系统设置**
3. 进入 **隐私与安全性**
4. 向下滚动到"安全性"部分
5. 找到被阻止的应用提示：

   ```
   已阻止使用"macLanuch"，因为来自身份不明的开发者。
   ```

6. 点击 **"仍要打开"** 按钮
7. 在弹出的对话框中点击"打开"
8. 输入管理员密码确认

#### 方法 3：终端移除隔离属性（适合开发者）

```bash
# 打开终端，运行以下命令：
xattr -cr /Applications/macLanuch.app

# 然后就可以正常双击打开了
open /Applications/macLanuch.app
```

**命令说明：**
- `xattr`: 查看/设置扩展属性
- `-c`: 清除所有属性
- `-r`: 递归处理（对 .app 包）
- 这样可以永久移除隔离标记

---

## 权限设置

应用需要以下权限才能正常工作。

### 1. 辅助功能权限（必需）

**用途：** 全局快捷键功能（Cmd+Space）

**设置步骤：**

1. 打开 **系统设置** → **隐私与安全性** → **辅助功能**
2. 点击左下角的锁图标🔒解锁
3. 输入管理员密码
4. 点击 **+** 按钮
5. 找到并添加 `macLanuch.app`
6. 确保应用前面的复选框已勾选 ✅

**如果没有授予权限：**
- ❌ 全局快捷键无法工作
- ❌ 无法通过 Cmd+Space 唤起启动台

### 2. Apple Events 权限（自动请求）

**用途：** 启动其他应用程序

**设置步骤：**
- 首次运行应用时会自动弹出权限请求
- 点击"允许"即可

**手动设置：**
1. 系统设置 → 隐私与安全性 → 自动化
2. 找到 `macLanuch`
3. 确保已勾选允许控制其他应用

---

## 使用方法

### 启动应用

安装完成后，有多种方式启动：

#### 方式 1：菜单栏图标
- 应用启动后会在菜单栏显示网格图标
- **点击图标** 打开启动台

#### 方式 2：全局快捷键
- 按 **Cmd + Space** 唤起启动台
- 可在设置中自定义快捷键

#### 方式 3：Spotlight 搜索
1. 按 Cmd + Space 打开 Spotlight
2. 输入 "macLanuch"
3. 按回车启动

### 基本功能

#### 1. 浏览应用
- 应用以网格形式显示（默认 7×5）
- 左右滑动或点击底部圆点切换页面

#### 2. 搜索应用
- 在顶部搜索栏输入应用名称
- 实时显示匹配结果
- 清空搜索恢复分页视图

#### 3. 启动应用
- 点击应用图标即可启动
- 启动台会自动关闭

#### 4. 编辑模式
- 点击搜索栏右侧的齿轮图标进入编辑模式
- 图标开始抖动
- 可以拖拽重新排列应用
- 点击 X 按钮删除应用（仅非系统应用）
- 点击完成按钮（✓）退出编辑模式

#### 5. 文件夹功能
- 在编辑模式下，拖拽一个应用到另一个应用上
- 自动创建文件夹
- 点击文件夹图标展开查看
- 从文件夹拖出应用可解散文件夹

### 设置

点击菜单栏图标 → **Settings** 打开设置界面：

#### 快捷键设置
- 启用/禁用全局快捷键
- 查看当前快捷键

#### 布局设置
- 列数调整（4-10）
- 行数调整（3-8）
- 图标大小调整（60-120）

#### 显示选项
- 显示系统应用
- 在 Dock 中显示应用图标
- 自动排列应用

### 关闭启动台

- 按 **Esc** 键
- 点击背景空白区域
- 再次点击菜单栏图标
- 按 Cmd + Space（如果启用了快捷键）

---

## 常见问题 (FAQ)

### Q1: 应用无法打开，提示"已损坏"

**解决方案：**
```bash
# 方法 1：移除隔离属性
xattr -cr /Applications/macLanuch.app

# 方法 2：重新下载并使用右键打开
```

### Q2: 全局快捷键不工作

**可能原因：**
1. 未授予辅助功能权限
2. 快捷键与其他应用冲突

**解决方案：**
1. 检查权限：系统设置 → 隐私与安全性 → 辅助功能
2. 检查是否与 Spotlight 冲突（系统默认 Cmd+Space）
3. 在应用设置中修改快捷键

### Q3: 某些应用没有显示

**可能原因：**
1. 应用安装在非标准目录
2. 应用的 Info.plist 不规范

**解决方案：**
应用会扫描以下目录：
- `/Applications`
- `/System/Applications`
- `~/Applications`（用户目录）

手动检查应用是否在这些目录中。

### Q4: 应用图标显示不正常

**解决方案：**
```bash
# 重启应用
killall macLanuch
open /Applications/macLanuch.app
```

### Q5: 如何卸载应用？

**卸载步骤：**
1. 退出应用（菜单栏图标 → Quit）
2. 在 Finder 中找到 `/Applications/macLanuch.app`
3. 拖到废纸篓
4. 清空废纸篓

**清除配置文件（可选）：**
```bash
# 删除应用配置
rm -rf ~/Library/Preferences/com.macLaunch.*
rm -rf ~/Library/Application\ Support/macLanuch
```

### Q6: 应用启动后立即退出

**可能原因：**
- 缺少必要权限
- 系统版本过低

**解决方案：**
1. 确保系统版本 ≥ macOS 14.0
2. 检查控制台日志：
   ```bash
   log stream --predicate 'process == "macLanuch"' --level debug
   ```

### Q7: 如何重置应用设置？

**重置步骤：**
```bash
# 删除所有配置
defaults delete com.macLaunch.macLanuch
```

---

## 更新应用

### 手动更新

1. 下载最新版本的 DMG
2. 按照安装步骤覆盖安装
3. 应用会保留之前的配置

### 检查版本

- 打开应用
- 点击菜单栏图标
- 查看关于信息

---

## 技术支持

### 获取帮助

- **GitHub Issues**: [https://github.com/whq123-blog/macLanuch/issues](https://github.com/whq123-blog/macLanuch/issues)
- **项目文档**: 查看 README.md

### 报告问题

提交 Issue 时请提供：
1. macOS 版本
2. 应用版本
3. 问题描述和截图
4. 控制台日志（如有）

---

## 系统要求详解

### 支持的 macOS 版本

| macOS 版本 | 代号 | 是否支持 |
|-----------|------|---------|
| macOS 15.0+ | Sequoia | ✅ 支持 |
| macOS 14.0+ | Sonoma | ✅ 支持 |
| macOS 13.x | Ventura | ❌ 不支持 |
| macOS 12.x | Monterey | ❌ 不支持 |

### 硬件要求

- **处理器**:
  - ✅ Apple Silicon (M1/M2/M3)
  - ✅ Intel Core 处理器（64位）

- **内存**: 建议 4GB 以上

- **存储空间**: 约 10MB

---

## 安全性说明

### 关于未签名应用

**为什么应用未签名？**
- 开源项目，无商业盈利
- 苹果开发者账号需 $99/年
- 应用完全安全，代码开源可审查

**应用安全性：**
- ✅ 代码完全开源
- ✅ 不收集任何用户数据
- ✅ 不联网，完全本地运行
- ✅ 可通过源代码自行编译

### 查看源代码

- **GitHub**: [https://github.com/whq123-blog/macLanuch](https://github.com/whq123-blog/macLanuch)
- 可自行审查代码或编译

---

## 开发者信息

- **作者**: cold.wang
- **GitHub**: [@whq123-blog](https://github.com/whq123-blog)
- **项目**: [macLanuch](https://github.com/whq123-blog/macLanuch)
- **许可证**: MIT License

---

## 更新日志

### v1.0.0 (2026-04-08)

**首次发布**

- ✅ 应用扫描和网格显示
- ✅ 分页导航
- ✅ 实时搜索
- ✅ 编辑模式（拖拽排列、删除）
- ✅ 文件夹功能
- ✅ 全局快捷键（Cmd+Space）
- ✅ 设置界面
- ✅ 数据持久化

---

**祝使用愉快！如有问题，欢迎在 GitHub 提交 Issue。** 🎉