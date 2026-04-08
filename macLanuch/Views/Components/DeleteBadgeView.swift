import SwiftUI

/// 删除徽章视图（红色 X 按钮）
struct DeleteBadgeView: View {
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            ZStack {
                Circle()
                    .fill(Color.white)
                    .frame(width: 24, height: 24)

                Image(systemName: "xmark.circle.fill")
                    .font(.system(size: 24))
                    .foregroundColor(.red)
            }
        }
        .buttonStyle(.plain)
    }
}