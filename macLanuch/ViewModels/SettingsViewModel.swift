import Foundation
import Combine
import AppKit

/// 设置视图模型
class SettingsViewModel: ObservableObject {
    // MARK: - Published Properties

    @Published var shortcutEnabled: Bool = true
    @Published var shortcutDisplay: String = "Cmd + Space"
    @Published var isEditingShortcut: Bool = false

    @Published var columns: Int = 7
    @Published var rows: Int = 5
    @Published var iconSize: CGFloat = 80

    @Published var showSystemApps: Bool = true
    @Published var showInDock: Bool = false
    @Published var autoArrange: Bool = true

    // MARK: - Private Properties

    private let persistenceService = PersistenceService.shared
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Initialization

    init() {
        loadSettings()
    }

    // MARK: - Public Methods

    /// 加载设置
    func loadSettings() {
        let settings = persistenceService.loadSettings()

        shortcutEnabled = settings.shortcutEnabled
        columns = settings.layoutConfig.columns
        rows = settings.layoutConfig.rows
        iconSize = settings.layoutConfig.iconSize
        showSystemApps = settings.showSystemApps
        autoArrange = settings.autoArrange

        // 快捷键显示字符串
        shortcutDisplay = "Cmd + Space"  // 简化版本
    }

    /// 保存设置
    func saveSettings() {
        let layoutConfig = LayoutConfig(
            columns: columns,
            rows: rows,
            iconSize: iconSize,
            iconSpacing: 20,
            pageIndicatorHeight: 40,
            searchBarHeight: 60
        )

        let settings = AppSettings(
            shortcutEnabled: shortcutEnabled,
            showSystemApps: showSystemApps,
            animationSpeed: 0.3,
            autoArrange: autoArrange,
            layoutConfig: layoutConfig
        )

        persistenceService.saveSettings(settings)

        // 应用 Dock 显示设置
        if showInDock {
            NSApp.setActivationPolicy(.regular)
        } else {
            NSApp.setActivationPolicy(.accessory)
        }

        // 重新注册快捷键
        if shortcutEnabled {
            GlobalShortcutService.shared.registerDefaultShortcut {
                WindowManagerService.shared.toggle()
            }
        } else {
            GlobalShortcutService.shared.unregister()
        }
    }

    /// 重置为默认设置
    func resetToDefault() {
        shortcutEnabled = true
        shortcutDisplay = "Cmd + Space"
        columns = 7
        rows = 5
        iconSize = 80
        showSystemApps = true
        showInDock = false
        autoArrange = true
    }
}