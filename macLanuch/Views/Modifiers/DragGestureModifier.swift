import SwiftUI

/// 拖拽手势修饰符
struct DragGestureModifier: ViewModifier {
    @Binding var isDragging: Bool
    @Binding var dragOffset: CGSize
    let isEditing: Bool
    let onDragEnd: (CGSize) -> Void  // 移除 @escaping，存储属性会自动推断为 escaping

    func body(content: Content) -> some View {
        content
            .offset(dragOffset)
            .scaleEffect(isDragging ? 1.1 : 1.0)
            .shadow(radius: isDragging ? 10 : 3)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        if isEditing {
                            isDragging = true
                            dragOffset = value.translation
                        }
                    }
                    .onEnded { value in
                        if isEditing {
                            isDragging = false
                            onDragEnd(value.translation)
                            dragOffset = .zero
                        }
                    }
            )
    }
}

extension View {
    /// 应用拖拽手势
    func draggable(
        isDragging: Binding<Bool>,
        dragOffset: Binding<CGSize>,
        isEditing: Bool,
        onDragEnd: @escaping (CGSize) -> Void
    ) -> some View {
        modifier(
            DragGestureModifier(
                isDragging: isDragging,
                dragOffset: dragOffset,
                isEditing: isEditing,
                onDragEnd: onDragEnd
            )
        )
    }
}