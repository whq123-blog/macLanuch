import Foundation
import AppKit
import CoreServices

/// 应用扫描服务
class AppScannerService {
    static let shared = AppScannerService()

    private init() {}

    /// 扫描系统中所有已安装应用
    func scanAllApplications() async -> [AppInfo] {
        var apps: [AppInfo] = []

        // 扫描标准应用目录
        let applicationPaths = [
            "/Applications",
            "/System/Applications",
            "/System/Applications/Utilities",
            "/Applications/Utilities",
            NSHomeDirectory() + "/Applications"
        ]

        for path in applicationPaths {
            let appsInPath = await scanDirectory(path)
            apps.append(contentsOf: appsInPath)
        }

        // 去重并排序
        let uniqueApps = Dictionary(grouping: apps, by: { $0.id })
            .compactMap { $0.value.first }
            .sorted { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }

        return uniqueApps
    }

    /// 扫描指定目录
    private func scanDirectory(_ path: String) async -> [AppInfo] {
        return await withCheckedContinuation { continuation in
            DispatchQueue.global(qos: .userInitiated).async {
                var apps: [AppInfo] = []
                let fileManager = FileManager.default

                do {
                    let contents = try fileManager.contentsOfDirectory(atPath: path)

                    for item in contents {
                        if item.hasSuffix(".app") {
                            let appPath = (path as NSString).appendingPathComponent(item)
                            if let appInfo = self.parseAppBundle(at: appPath) {
                                apps.append(appInfo)
                            }
                        }
                    }
                } catch {
                    print("Error scanning directory \(path): \(error)")
                }

                continuation.resume(returning: apps)
            }
        }
    }

    /// 解析应用 Bundle
    private func parseAppBundle(at path: String) -> AppInfo? {
        let url = URL(fileURLWithPath: path)
        let bundle = Bundle(url: url)

        guard let bundleIdentifier = bundle?.bundleIdentifier else {
            return nil
        }

        // 获取应用名称
        let displayName = bundle?.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String
        let name = bundle?.object(forInfoDictionaryKey: "CFBundleName") as? String
        let appName = displayName ?? name ?? URL(fileURLWithPath: path).deletingPathExtension().lastPathComponent

        // 获取图标路径
        let iconPath = bundle?.path(forResource: "AppIcon", ofType: "icns")
        let iconFileName = bundle?.object(forInfoDictionaryKey: "CFBundleIconFile") as? String
        let iconPathAlt = iconFileName != nil ? bundle?.path(forResource: iconFileName!, ofType: "icns") : nil

        // 获取版本号
        let version = bundle?.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String

        // 判断是否为系统应用
        let isSystemApp = path.hasPrefix("/System/")

        return AppInfo(
            id: bundleIdentifier,
            name: appName,
            bundlePath: path,
            iconPath: iconPath ?? iconPathAlt,
            version: version,
            isSystemApp: isSystemApp
        )
    }

    /// 监听应用安装/卸载事件
    func startMonitoringChanges() {
        // 监听应用变化通知
        NotificationCenter.default.addObserver(
            forName: NSWorkspace.didLaunchApplicationNotification,
            object: nil,
            queue: .main
        ) { notification in
            // 应用启动时的处理（可选）
        }

        NotificationCenter.default.addObserver(
            forName: NSWorkspace.didTerminateApplicationNotification,
            object: nil,
            queue: .main
        ) { notification in
            // 应用终止时的处理（可选）
        }
    }
}