import AppKit
import Combine
import SwiftUI

class AppDelegate: NSObject, NSApplicationDelegate {
    private var statusItem: NSStatusItem?
    private var launchpadWindow: NSWindow?
    private var settingsWindow: NSWindow?

    func applicationDidFinishLaunching(_ notification: Notification) {
        setupStatusBar()
        setupGlobalShortcut()

        // 隐藏主窗口，只在需要时显示启动台
        NSApp.windows.forEach { $0.close() }

        // 加载用户设置并应用
        let settings = PersistenceService.shared.loadSettings()
        if settings.autoArrange {
            NSApp.setActivationPolicy(.accessory)
        } else {
            NSApp.setActivationPolicy(.regular)
        }
    }

    private func setupStatusBar() {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)

        if let button = statusItem?.button {
            button.image = NSImage(systemSymbolName: "grid.circle.fill", accessibilityDescription: "Launchpad")
            button.action = #selector(statusBarButtonClicked)
        }

        let menu = NSMenu()
        menu.addItem(NSMenuItem(title: "Show Launchpad", action: #selector(showLaunchpad), keyEquivalent: ""))
        menu.addItem(NSMenuItem(title: "Settings", action: #selector(openSettings), keyEquivalent: ","))
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Quit", action: #selector(quitApp), keyEquivalent: "q"))

        statusItem?.menu = menu
    }

    private func setupGlobalShortcut() {
        GlobalShortcutService.shared.registerDefaultShortcut { [weak self] in
            self?.toggleLaunchpad()
        }
    }

    @objc private func statusBarButtonClicked() {
        toggleLaunchpad()
    }

    @objc private func showLaunchpad() {
        WindowManagerService.shared.show()
    }

    @objc private func toggleLaunchpad() {
        WindowManagerService.shared.toggle()
    }

    @objc private func openSettings() {
        // 如果设置窗口已存在，直接显示
        if let window = settingsWindow {
            window.makeKeyAndOrderFront(nil)
            NSApp.activate(ignoringOtherApps: true)
            return
        }

        // 创建新的设置窗口
        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 500, height: 600),
            styleMask: [.titled, .closable],
            backing: .buffered,
            defer: false
        )

        window.title = "Settings"
        window.center()
        window.isReleasedWhenClosed = false

        // 设置 SwiftUI 内容视图
        let settingsViewModel = SettingsViewModel()
        let contentView = NSHostingView(rootView: SettingsView(viewModel: settingsViewModel))
        window.contentView = contentView

        self.settingsWindow = window
        window.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
    }

    @objc private func quitApp() {
        NSApp.terminate(nil)
    }

    // 点击 Dock 图标时调用
    func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
        toggleLaunchpad()
        return false
    }
}