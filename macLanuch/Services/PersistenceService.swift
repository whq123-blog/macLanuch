import Foundation

/// 数据持久化服务
class PersistenceService {
    static let shared = PersistenceService()

    private let defaults = UserDefaults.standard
    private let layoutKey = "com.macLaunch.userLayout"
    private let settingsKey = "com.macLaunch.settings"

    private init() {}

    // MARK: - 布局数据持久化

    /// 保存布局数据
    func saveLayoutData(_ layout: UserLayoutData) {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted

        do {
            let data = try encoder.encode(layout)
            defaults.set(data, forKey: layoutKey)
            defaults.synchronize()
            print("Layout data saved successfully")
        } catch {
            print("Failed to save layout data: \(error)")
        }
    }

    /// 加载布局数据
    func loadLayoutData() -> UserLayoutData? {
        guard let data = defaults.data(forKey: layoutKey) else {
            print("No saved layout data found")
            return nil
        }

        do {
            let layout = try JSONDecoder().decode(UserLayoutData.self, from: data)
            print("Layout data loaded successfully")
            return layout
        } catch {
            print("Failed to load layout data: \(error)")
            return nil
        }
    }

    /// 清除布局数据
    func clearLayoutData() {
        defaults.removeObject(forKey: layoutKey)
        defaults.synchronize()
        print("Layout data cleared")
    }

    // MARK: - 设置数据持久化

    /// 保存设置数据
    func saveSettings(_ settings: AppSettings) {
        do {
            let data = try JSONEncoder().encode(settings)
            defaults.set(data, forKey: settingsKey)
            defaults.synchronize()
            print("Settings saved successfully")
        } catch {
            print("Failed to save settings: \(error)")
        }
    }

    /// 加载设置数据
    func loadSettings() -> AppSettings {
        guard let data = defaults.data(forKey: settingsKey),
              let settings = try? JSONDecoder().decode(AppSettings.self, from: data) else {
            print("No saved settings found, using default settings")
            return AppSettings.default
        }
        return settings
    }

    /// 清除设置数据
    func clearSettings() {
        defaults.removeObject(forKey: settingsKey)
        defaults.synchronize()
        print("Settings cleared")
    }
}

/// 应用设置模型
struct AppSettings: Codable {
    var shortcutEnabled: Bool
    var showSystemApps: Bool
    var animationSpeed: Double
    var autoArrange: Bool
    var layoutConfig: LayoutConfig

    static let `default` = AppSettings(
        shortcutEnabled: true,
        showSystemApps: true,
        animationSpeed: 0.3,
        autoArrange: true,
        layoutConfig: LayoutConfig.default
    )
}