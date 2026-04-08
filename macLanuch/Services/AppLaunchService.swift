import AppKit

/// 应用启动服务
class AppLaunchService {
    static let shared = AppLaunchService()

    private init() {}

    /// 启动应用
    func launchApp(_ app: AppInfo) {
        let workspace = NSWorkspace.shared
        let url = URL(fileURLWithPath: app.bundlePath)

        let configuration = NSWorkspace.OpenConfiguration()
        configuration.activates = true

        workspace.openApplication(at: url, configuration: configuration) { runningApp, error in
            if let error = error {
                print("Failed to launch app \(app.name): \(error.localizedDescription)")
            } else {
                print("Successfully launched \(app.name)")
            }
        }
    }

    /// 卸载应用（移到废纸篓）
    func uninstallApp(_ app: AppInfo, completion: @escaping (Bool) -> Void) {
        // 系统应用不能卸载
        if app.isSystemApp {
            print("Cannot uninstall system app: \(app.name)")
            completion(false)
            return
        }

        let fileManager = FileManager.default
        let url = URL(fileURLWithPath: app.bundlePath)

        var resultingURL: NSURL?
        do {
            try fileManager.trashItem(at: url, resultingItemURL: &resultingURL)
            if let trashURL = resultingURL as URL? {
                print("Moved \(app.name) to trash: \(trashURL.path)")
            }
            completion(true)
        } catch {
            print("Failed to uninstall app \(app.name): \(error)")
            completion(false)
        }
    }

    /// 检查应用是否正在运行
    func isAppRunning(_ app: AppInfo) -> Bool {
        let runningApps = NSWorkspace.shared.runningApplications
        return runningApps.contains { $0.bundleIdentifier == app.id }
    }

    /// 激活正在运行的应用
    func activateApp(_ app: AppInfo) {
        let runningApps = NSWorkspace.shared.runningApplications
        let targetApp = runningApps.first { $0.bundleIdentifier == app.id }

        if let targetApp = targetApp {
            targetApp.activate()
        } else {
            // 如果应用未运行，启动它
            launchApp(app)
        }
    }
}