import Foundation
import Combine

/// 主视图模型
class LaunchpadViewModel: ObservableObject {
    // MARK: - Published Properties

    @Published var apps: [AppInfo] = []
    @Published var pages: [Page] = []
    @Published var folders: [Folder] = []
    @Published var searchText: String = ""
    @Published var isEditing: Bool = false
    @Published var isLoading: Bool = true
    @Published var currentPage: Int = 0

    // MARK: - Private Properties

    private let appScanner = AppScannerService.shared
    private let persistenceService = PersistenceService.shared
    private let appLaunchService = AppLaunchService.shared
    private let layoutConfig = LayoutConfig.default
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Computed Properties

    /// 搜索过滤后的应用列表
    var filteredApps: [AppInfo] {
        if searchText.isEmpty {
            return apps
        }
        return apps.filter {
            $0.name.localizedCaseInsensitiveContains(searchText)
        }
    }

    // MARK: - Initialization

    init() {
        loadApplications()
    }

    // MARK: - Public Methods

    /// 加载应用列表
    func loadApplications() {
        Task {
            isLoading = true

            // 扫描应用
            let scannedApps = await appScanner.scanAllApplications()

            await MainActor.run {
                self.apps = scannedApps

                // 加载用户布局配置
                if let layoutData = persistenceService.loadLayoutData() {
                    applyLayout(layoutData)
                } else {
                    // 首次运行，使用默认布局
                    createDefaultLayout()
                }

                isLoading = false
            }
        }
    }

    /// 启动应用
    func launchApp(_ app: AppInfo) {
        appLaunchService.launchApp(app)
        WindowManagerService.shared.hide()
    }

    /// 切换编辑模式
    func toggleEditMode() {
        isEditing.toggle()
    }

    /// 删除应用
    func deleteApp(_ app: AppInfo) {
        appLaunchService.uninstallApp(app) { [weak self] success in
            if success {
                DispatchQueue.main.async {
                    self?.apps.removeAll { $0.id == app.id }
                    self?.rebuildPages()
                    self?.saveLayout()
                }
            }
        }
    }

    /// 移动应用（从位置到新位置）
    func moveApp(fromPosition: Int, toPosition: Int, onPage: Int) {
        guard onPage >= 0 && onPage < pages.count else { return }
        guard fromPosition >= 0 && fromPosition < pages[onPage].apps.count else { return }
        guard toPosition >= 0 && toPosition < pages[onPage].apps.count else { return }

        let page = pages[onPage]
        let fromApp = page.apps[fromPosition]
        let toApp = page.apps[toPosition]

        // 交换位置
        pages[onPage].apps[fromPosition] = toApp
        pages[onPage].apps[toPosition] = fromApp

        saveLayout()
    }

    /// 创建文件夹（拖拽两个应用合并）
    func createFolder(with app1: AppInfo, and app2: AppInfo, at page: Int, position: Int) {
        // 创建新文件夹
        let folder = Folder(
            name: "New Folder",
            apps: [app1.id, app2.id],
            page: page,
            position: position
        )

        folders.append(folder)

        // 从页面中移除这两个应用，替换为文件夹
        if page >= 0 && page < pages.count {
            // 找到 app1 和 app2 的位置
            for (index, app) in pages[page].apps.enumerated() {
                if app?.id == app1.id || app?.id == app2.id {
                    pages[page].apps[index] = nil  // 移除应用
                }
            }

            // 在指定位置添加文件夹引用
            // 这里简化处理，实际需要更新页面布局
        }

        saveLayout()
    }

    /// 添加应用到文件夹
    func addAppToFolder(_ app: AppInfo, folderId: String) {
        guard let folderIndex = folders.firstIndex(where: { $0.id == folderId }) else { return }

        folders[folderIndex].apps.append(app.id)

        // 从页面中移除应用
        for pageIndex in pages.indices {
            for appIndex in pages[pageIndex].apps.indices {
                if pages[pageIndex].apps[appIndex]?.id == app.id {
                    pages[pageIndex].apps[appIndex] = nil
                }
            }
        }

        saveLayout()
    }

    /// 从文件夹移除应用
    func removeAppFromFolder(_ app: AppInfo, folderId: String) {
        guard let folderIndex = folders.firstIndex(where: { $0.id == folderId }) else { return }

        folders[folderIndex].apps.removeAll { $0 == app.id }

        // 如果文件夹为空，删除文件夹
        if folders[folderIndex].apps.isEmpty {
            folders.remove(at: folderIndex)
        }

        // 将应用添加回页面（找到第一个空位）
        for pageIndex in pages.indices {
            if let emptyIndex = pages[pageIndex].findFirstEmptySlot() {
                pages[pageIndex].apps[emptyIndex] = app
                break
            }
        }

        saveLayout()
    }

    /// 重命名文件夹
    func renameFolder(_ folderId: String, newName: String) {
        guard let folderIndex = folders.firstIndex(where: { $0.id == folderId }) else { return }

        folders[folderIndex].name = newName
        saveLayout()
    }

    /// 删除文件夹（解散，应用返回页面）
    func deleteFolder(_ folderId: String) {
        guard let folder = folders.firstIndex(where: { $0.id == folderId }) else { return }
        let folderData = folders[folder]

        // 将文件夹内的应用返回到页面
        for appId in folderData.apps {
            if let app = apps.first(where: { $0.id == appId }) {
                // 找到第一个空位
                for pageIndex in pages.indices {
                    if let emptyIndex = pages[pageIndex].findFirstEmptySlot() {
                        pages[pageIndex].apps[emptyIndex] = app
                        break
                    }
                }
            }
        }

        folders.remove(at: folder)
        saveLayout()
    }

    /// 获取文件夹内的应用列表
    func getAppsInFolder(_ folderId: String) -> [AppInfo] {
        guard let folder = folders.first(where: { $0.id == folderId }) else { return [] }

        return folder.apps.compactMap { appId in
            apps.first(where: { $0.id == appId })
        }
    }

    // MARK: - Private Methods

    /// 创建默认布局
    private func createDefaultLayout() {
        let appsPerPage = layoutConfig.appsPerPage

        var pages: [Page] = []
        var currentPageApps: [AppInfo?] = []

        for (index, app) in apps.enumerated() {
            if currentPageApps.count == appsPerPage {
                // 完成当前页面
                pages.append(Page(
                    id: pages.count,
                    apps: currentPageApps,
                    folders: [],
                    maxApps: appsPerPage
                ))
                currentPageApps = []
            }

            currentPageApps.append(app)
        }

        // 添加最后一页（填充空位）
        if !currentPageApps.isEmpty {
            while currentPageApps.count < appsPerPage {
                currentPageApps.append(nil)
            }
            pages.append(Page(
                id: pages.count,
                apps: currentPageApps,
                folders: [],
                maxApps: appsPerPage
            ))
        }

        self.pages = pages
        self.folders = []
    }

    /// 应用保存的布局配置
    private func applyLayout(_ layoutData: UserLayoutData) {
        // 重建页面结构
        let appsPerPage = layoutConfig.appsPerPage
        var pages: [Page] = []

        // 根据应用数量创建足够的页面
        let pageCount = max(1, (apps.count + layoutData.folders.count) / appsPerPage + 1)

        for pageIndex in 0..<pageCount {
            var pageApps: [AppInfo?] = Array(repeating: nil, count: appsPerPage)

            // 填充应用到正确位置
            for position in layoutData.appPositions {
                if position.page == pageIndex {
                    if let app = apps.first(where: { $0.id == position.appId }) {
                        pageApps[position.position] = app
                    }
                }
            }

            // 如果没有位置数据，使用默认排序填充
            if layoutData.appPositions.isEmpty {
                let startIndex = pageIndex * appsPerPage
                for i in 0..<appsPerPage {
                    if startIndex + i < apps.count {
                        pageApps[i] = apps[startIndex + i]
                    }
                }
            }

            pages.append(Page(
                id: pageIndex,
                apps: pageApps,
                folders: [],
                maxApps: appsPerPage
            ))
        }

        self.pages = pages
        self.folders = layoutData.folders
    }

    /// 重建页面（在应用增删后）
    private func rebuildPages() {
        createDefaultLayout()
    }

    /// 保存布局配置
    func saveLayout() {
        let layoutData = UserLayoutData(
            appPositions: buildAppPositions(),
            folders: folders
        )
        persistenceService.saveLayoutData(layoutData)
    }

    /// 构建应用位置数据
    private func buildAppPositions() -> [AppPosition] {
        var positions: [AppPosition] = []

        for page in pages {
            for (positionIndex, app) in page.apps.enumerated() {
                if let app = app {
                    positions.append(AppPosition(
                        appId: app.id,
                        page: page.id,
                        position: positionIndex
                    ))
                }
            }
        }

        return positions
    }
}