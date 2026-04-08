import AppKit
import SwiftUI
import Combine

/// 窗口管理服务
class WindowManagerService: ObservableObject {
    static let shared = WindowManagerService()

    private var window: NSWindow?
    @Published var isVisible: Bool = false

    private init() {}

    /// 创建启动台窗口
    func createWindow() -> NSWindow {
        let screenFrame = NSScreen.main?.frame ?? NSRect(x: 0, y: 0, width: 1440, height: 900)

        let window = NSWindow(
            contentRect: screenFrame,
            styleMask: [.borderless],
            backing: .buffered,
            defer: false
        )

        configureWindow(window)

        // 设置 SwiftUI 内容视图
        let contentView = NSHostingView(rootView: LaunchpadView())
        window.contentView = contentView

        self.window = window
        return window
    }

    /// 配置窗口属性
    private func configureWindow(_ window: NSWindow) {
        // 窗口层级 - 最高层级，覆盖 Dock 和菜单栏
        window.level = .screenSaver

        // 背景设置
        window.backgroundColor = .clear
        window.isOpaque = false
        window.hasShadow = false

        // 行为设置
        window.collectionBehavior = [
            .canJoinAllSpaces,       // 在所有空间显示
            .fullScreenAuxiliary,    // 全屏应用时也能显示
            .transient               // 不在 Cmd+Tab 中显示
        ]

        window.hidesOnDeactivate = false
        window.ignoresMouseEvents = false
        window.acceptsMouseMovedEvents = true

        // 阻止窗口出现在 Mission Control 中
        window.styleMask.insert(.fullSizeContentView)

        // 设置窗口代理（可选）
        // window.delegate = self
    }

    /// 显示窗口
    func show() {
        let window = window ?? createWindow()

        // 初始化窗口状态（用于动画）
        window.alphaValue = 0
        window.contentView?.wantsLayer = true
        window.contentView?.layer?.transform = CATransform3DMakeScale(0.8, 0.8, 1.0)

        window.makeKeyAndOrderFront(nil)

        // 打开动画
        NSAnimationContext.runAnimationGroup { context in
            context.duration = 0.25
            context.timingFunction = CAMediaTimingFunction(name: .easeOut)

            window.animator().alphaValue = 1.0

            // 缩放动画
            let scaleAnimation = CABasicAnimation(keyPath: "transform")
            scaleAnimation.fromValue = CATransform3DMakeScale(0.8, 0.8, 1.0)
            scaleAnimation.toValue = CATransform3DIdentity
            scaleAnimation.duration = 0.25
            scaleAnimation.timingFunction = CAMediaTimingFunction(name: .easeOut)

            window.contentView?.layer?.add(scaleAnimation, forKey: "scale")
            window.contentView?.layer?.transform = CATransform3DIdentity
        }

        isVisible = true
        NSApp.activate(ignoringOtherApps: true)
    }

    /// 隐藏窗口
    func hide() {
        guard let window = window else { return }

        // 关闭动画
        NSAnimationContext.runAnimationGroup { context in
            context.duration = 0.2
            context.timingFunction = CAMediaTimingFunction(name: .easeIn)

            window.animator().alphaValue = 0

            // 缩放动画
            let scaleAnimation = CABasicAnimation(keyPath: "transform")
            scaleAnimation.fromValue = CATransform3DIdentity
            scaleAnimation.toValue = CATransform3DMakeScale(0.8, 0.8, 1.0)
            scaleAnimation.duration = 0.2
            scaleAnimation.timingFunction = CAMediaTimingFunction(name: .easeIn)

            window.contentView?.layer?.add(scaleAnimation, forKey: "scale")
            window.contentView?.layer?.transform = CATransform3DMakeScale(0.8, 0.8, 1.0)
        } completionHandler: {
            window.orderOut(nil)
            self.isVisible = false
        }
    }

    /// 切换窗口显示状态
    func toggle() {
        if isVisible {
            hide()
        } else {
            show()
        }
    }

    /// 关闭并销毁窗口
    func destroyWindow() {
        if let window = window {
            window.close()
            self.window = nil
        }
        isVisible = false
    }
}