import SwiftUI
import AppKit

/// 应用图标视图
struct AppIconView: View {
    let app: AppInfo
    @Binding var isEditing: Bool
    let onTap: () -> Void
    let onDelete: (() -> Void)?
    let onDragStart: (() -> Void)?
    let onDragEnd: ((AppInfo) -> Void)?

    @State private var isDragging = false
    @State private var dragOffset: CGSize = .zero

    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                // 应用图标
                Image(nsImage: app.loadIcon())
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 80, height: 80)
                    .wiggle(isWiggling: isEditing)
                    .draggable(
                        isDragging: $isDragging,
                        dragOffset: $dragOffset,
                        isEditing: isEditing,
                        onDragEnd: { translation in
                            // 计算拖拽结束位置并通知父视图
                            onDragEnd?(app)
                        }
                    )
                    .onTapGesture {
                        if !isEditing {
                            onTap()
                        }
                    }

                // 删除徽章（编辑模式下的非系统应用）
                if isEditing && onDelete != nil {
                    VStack {
                        HStack {
                            Spacer()
                            DeleteBadgeView(onTap: onDelete!)
                                .offset(x: 35, y: -35)
                        }
                        Spacer()
                    }
                    .frame(width: 80, height: 80)
                }
            }
            .frame(width: 80, height: 80)

            // 应用名称
            Text(app.name)
                .font(.system(size: 13))
                .foregroundColor(.white)
                .lineLimit(1)
                .truncationMode(.tail)
                .shadow(radius: 1)
                .frame(maxWidth: 90)
        }
    }
}