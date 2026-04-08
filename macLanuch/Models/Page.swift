import Foundation

struct Page: Identifiable {
    let id: Int
    var apps: [AppInfo?]              // 可选，因为有空位
    var folders: [Folder]
    let maxApps: Int

    /// 页面是否为空
    var isEmpty: Bool {
        apps.allSatisfy { $0 == nil } && folders.isEmpty
    }

    /// 获取指定位置的应用
    func app(at position: Int) -> AppInfo? {
        guard position >= 0 && position < apps.count else { return nil }
        return apps[position]
    }

    /// 设置指定位置的应用
    mutating func setApp(at position: Int, app: AppInfo?) {
        guard position >= 0 && position < apps.count else { return }
        apps[position] = app
    }

    /// 查找第一个空位
    func findFirstEmptySlot() -> Int? {
        return apps.firstIndex(where: { $0 == nil })
    }

    /// 应用数量（包括文件夹中的应用）
    var totalAppCount: Int {
        let appsCount = apps.compactMap { $0 }.count
        let folderAppsCount = folders.reduce(0) { $0 + $1.apps.count }
        return appsCount + folderAppsCount
    }
}