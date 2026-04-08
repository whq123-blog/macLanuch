import SwiftUI
import UniformTypeIdentifiers

/// 应用网格视图（单页）
struct AppGridView: View {
    let apps: [AppInfo?]
    @Binding var isEditing: Bool
    let onAppTap: (AppInfo) -> Void
    let onAppDelete: (AppInfo) -> Void
    let onAppMove: (Int, Int) -> Void          // 从位置移动到新位置
    let onCreateFolder: (AppInfo, AppInfo) -> Void  // 创建文件夹（两个应用）

    @State private var draggedApp: AppInfo?
    @State private var dropTargetIndex: Int?

    // 直接使用常量，避免初始化问题
    private let columns = Array(
        repeating: GridItem(.fixed(100), spacing: 20),
        count: LayoutConfig.default.columns
    )
    private let iconSpacing = LayoutConfig.default.iconSpacing

    var body: some View {
        LazyVGrid(columns: columns, spacing: iconSpacing) {
            ForEach(Array(apps.enumerated()), id: \.offset) { index, app in
                if let app = app {
                    AppIconView(
                        app: app,
                        isEditing: $isEditing,
                        onTap: { onAppTap(app) },
                        onDelete: app.isSystemApp ? nil : { onAppDelete(app) },
                        onDragStart: {
                            draggedApp = app
                        } as (() -> Void)?,
                        onDragEnd: { droppedApp in
                            handleDragEnd(droppedApp, at: index)
                        } as ((AppInfo) -> Void)?
                    )
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(dropTargetIndex == index ? Color.blue.opacity(0.3) : Color.clear)
                    )
                    .onDrop(
                        of: [UTType.text],
                        delegate: AppDropDelegate(
                            app: app,
                            index: index,
                            apps: apps,
                            draggedApp: $draggedApp,
                            dropTargetIndex: $dropTargetIndex,
                            onDrop: { fromIndex, toIndex in
                                onAppMove(fromIndex, toIndex)
                            },
                            onCreateFolder: { app1, app2 in
                                onCreateFolder(app1, app2)
                            }
                        )
                    )
                } else {
                    // 空位占位符（可以拖放到这里）
                    Color.clear
                        .frame(width: 80, height: 100)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(dropTargetIndex == index ? Color.green.opacity(0.3) : Color.clear)
                        )
                        .onDrop(
                            of: [UTType.text],
                            delegate: EmptySlotDropDelegate(
                                index: index,
                                draggedApp: $draggedApp,
                                dropTargetIndex: $dropTargetIndex,
                                onDrop: { fromIndex, toIndex in
                                    onAppMove(fromIndex, toIndex)
                                }
                            )
                        )
                }
            }
        }
        .padding()
    }

    private func handleDragEnd(_ app: AppInfo, at index: Int) {
        draggedApp = nil
        dropTargetIndex = nil
    }
}

/// 应用拖放代理（拖到另一个应用上）
struct AppDropDelegate: DropDelegate {
    let app: AppInfo
    let index: Int
    let apps: [AppInfo?]
    @Binding var draggedApp: AppInfo?
    @Binding var dropTargetIndex: Int?
    let onDrop: (Int, Int) -> Void
    let onCreateFolder: (AppInfo, AppInfo) -> Void

    func dropEntered(info: DropInfo) {
        dropTargetIndex = index
    }

    func dropExited(info: DropInfo) {
        dropTargetIndex = nil
    }

    func performDrop(info: DropInfo) -> Bool {
        guard let draggedApp = draggedApp else { return false }

        // 查找被拖拽应用的位置
        if let fromIndex = apps.firstIndex(where: { $0?.id == draggedApp.id }) {
            if fromIndex != index {
                // 拖到不同的应用上 -> 创建文件夹
                onCreateFolder(draggedApp, app)
            } else {
                // 拖到同一个位置 -> 不处理
                return false
            }
        }

        self.draggedApp = nil
        dropTargetIndex = nil
        return true
    }
}

/// 空位拖放代理（拖到空位上）
struct EmptySlotDropDelegate: DropDelegate {
    let index: Int
    @Binding var draggedApp: AppInfo?
    @Binding var dropTargetIndex: Int?
    let onDrop: (Int, Int) -> Void

    func dropEntered(info: DropInfo) {
        dropTargetIndex = index
    }

    func dropExited(info: DropInfo) {
        dropTargetIndex = nil
    }

    func performDrop(info: DropInfo) -> Bool {
        guard let draggedApp = draggedApp else { return false }

        // 通知父视图移动应用
        // 这里简化处理，实际需要查找原位置
        // onDrop(fromIndex, index)

        self.draggedApp = nil
        dropTargetIndex = nil
        return true
    }
}