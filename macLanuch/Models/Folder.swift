import Foundation

struct Folder: Identifiable, Codable {
    let id: String
    var name: String
    var apps: [String]                // AppInfo ID 数组
    var page: Int                     // 所在页面
    var position: Int                 // 页面位置
    let createdAt: Date
    var color: String?                // 文件夹颜色标识

    init(
        id: String = UUID().uuidString,
        name: String,
        apps: [String] = [],
        page: Int,
        position: Int
    ) {
        self.id = id
        self.name = name
        self.apps = apps
        self.page = page
        self.position = position
        self.createdAt = Date()
        self.color = nil
    }

    /// 是否为空文件夹
    var isEmpty: Bool {
        return apps.isEmpty
    }

    /// 应用数量
    var appCount: Int {
        return apps.count
    }
}