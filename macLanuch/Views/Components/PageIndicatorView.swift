import SwiftUI

/// 页面指示器视图（底部小圆点）
struct PageIndicatorView: View {
    let totalPages: Int
    @Binding var currentPage: Int

    var body: some View {
        HStack(spacing: 8) {
            ForEach(0..<totalPages, id: \.self) { index in
                Circle()
                    .fill(index == currentPage ? Color.white : Color.white.opacity(0.4))
                    .frame(width: 8, height: 8)
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            currentPage = index
                        }
                    }
            }
        }
    }
}