import Foundation

/// 应用位置配置（用于持久化）
struct AppPosition: Codable {
    let appId: String
    let page: Int
    let position: Int
    var folderId: String?

    init(appId: String, page: Int, position: Int, folderId: String? = nil) {
        self.appId = appId
        self.page = page
        self.position = position
        self.folderId = folderId
    }
}

/// 用户布局数据（持久化整体结构）
struct UserLayoutData: Codable {
    var version: Int = 1
    var appPositions: [AppPosition]
    var folders: [Folder]
    var lastUpdated: Date

    init(appPositions: [AppPosition], folders: [Folder]) {
        self.appPositions = appPositions
        self.folders = folders
        self.lastUpdated = Date()
    }
}