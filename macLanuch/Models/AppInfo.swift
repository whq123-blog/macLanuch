import Foundation
import AppKit

struct AppInfo: Identifiable, Codable, Hashable {
    let id: String                    // Bundle Identifier
    let name: String                  // 应用名称
    let bundlePath: String            // 应用路径
    let iconPath: String?             // 图标路径
    let version: String?              // 版本号
    let isSystemApp: Bool             // 是否为系统应用

    // 运行时属性（不持久化）
    var page: Int = 0
    var position: Int = 0
    var folderId: String?

    // 哈希和相等性判断基于 id
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: AppInfo, rhs: AppInfo) -> Bool {
        return lhs.id == rhs.id
    }

    /// 加载应用图标
    func loadIcon() -> NSImage {
        // 尝试从缓存加载
        if let cached = IconCache.shared.get(for: id) {
            return cached
        }

        // 从图标路径加载
        if let iconPath = iconPath {
            if let image = NSImage(contentsOfFile: iconPath) {
                IconCache.shared.set(image, for: id)
                return image
            }
        }

        // 使用 NSWorkspace 获取图标
        let icon = NSWorkspace.shared.icon(forFile: bundlePath)
        icon.size = NSSize(width: 80, height: 80)
        IconCache.shared.set(icon, for: id)
        return icon
    }
}