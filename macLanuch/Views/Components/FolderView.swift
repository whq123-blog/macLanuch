import SwiftUI
import AppKit

/// 文件夹视图
struct FolderView: View {
    let folder: Folder
    let apps: [AppInfo]                  // 文件夹内的应用列表
    @Binding var isEditing: Bool
    @State private var isExpanded = false
    let onAppTap: (AppInfo) -> Void

    var body: some View {
        VStack(spacing: 8) {
            // 文件夹图标
            ZStack {
                // 文件夹背景
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 80, height: 80)

                // 显示前 4 个应用的图标
                if apps.count >= 4 {
                    VStack(spacing: 2) {
                        HStack(spacing: 2) {
                            ForEach(0..<2) { i in
                                if i < apps.count {
                                    Image(nsImage: apps[i].loadIcon())
                                        .resizable()
                                        .frame(width: 35, height: 35)
                                        .cornerRadius(4)
                                }
                            }
                        }
                        HStack(spacing: 2) {
                            ForEach(2..<4) { i in
                                if i < apps.count {
                                    Image(nsImage: apps[i].loadIcon())
                                        .resizable()
                                        .frame(width: 35, height: 35)
                                        .cornerRadius(4)
                                }
                            }
                        }
                    }
                    .padding(4)
                } else if apps.count > 0 {
                    // 如果应用少于 4 个，显示部分图标
                    VStack(spacing: 2) {
                        ForEach(apps) { app in
                            Image(nsImage: app.loadIcon())
                                .resizable()
                                .frame(width: 35, height: 35)
                                .cornerRadius(4)
                        }
                    }
                    .padding(4)
                }
            }
            .frame(width: 80, height: 80)
            .onTapGesture {
                withAnimation(.easeInOut(duration: 0.3)) {
                    isExpanded = true
                }
            }

            // 文件夹名称
            Text(folder.name)
                .font(.system(size: 13))
                .foregroundColor(.white)
                .lineLimit(1)
                .truncationMode(.tail)
                .shadow(radius: 1)
                .frame(maxWidth: 90)
        }
        .sheet(isPresented: $isExpanded) {
            FolderOverlayView(
                folder: folder,
                apps: apps,
                isEditing: $isEditing,
                onAppTap: onAppTap,
                onClose: { isExpanded = false }
            )
        }
    }
}