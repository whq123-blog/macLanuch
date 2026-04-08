import SwiftUI

/// 文件夹展开视图（覆盖层）
struct FolderOverlayView: View {
    let folder: Folder
    let apps: [AppInfo]
    @Binding var isEditing: Bool
    let onAppTap: (AppInfo) -> Void
    let onClose: () -> Void

    @Environment(\.dismiss) var dismiss

    private let columns = Array(
        repeating: GridItem(.fixed(90), spacing: 16),
        count: 4
    )

    var body: some View {
        ZStack {
            // 半透明背景（点击关闭）
            Color.black.opacity(0.5)
                .ignoresSafeArea()
                .onTapGesture {
                    dismiss()
                    onClose()
                }

            // 文件夹内容
            VStack(spacing: 20) {
                // 文件夹标题
                Text(folder.name)
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.white)

                // 应用网格
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(apps) { app in
                        AppIconView(
                            app: app,
                            isEditing: $isEditing,
                            onTap: {
                                onAppTap(app)
                                dismiss()
                                onClose()
                            },
                            onDelete: nil,
                            onDragStart: nil,
                            onDragEnd: nil
                        )
                    }
                }
                .padding()

                // 关闭按钮（可选）
                Button(action: {
                    dismiss()
                    onClose()
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 32))
                        .foregroundColor(.white.opacity(0.7))
                }
                .buttonStyle(.plain)
                .padding(.bottom, 20)
            }
            .frame(maxWidth: 500, maxHeight: 400)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(.ultraThinMaterial)
            )
        }
    }
}