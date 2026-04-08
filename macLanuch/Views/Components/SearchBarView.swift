import SwiftUI

/// 搜索栏视图
struct SearchBarView: View {
    @Binding var text: String

    var body: some View {
        HStack {
            // 搜索图标
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
                .font(.system(size: 18))

            // 搜索输入框
            TextField("Search", text: $text)
                .textFieldStyle(.plain)
                .font(.system(size: 18))
                .foregroundColor(.white)

            // 清空按钮
            if !text.isEmpty {
                Button(action: {
                    text = ""
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray.opacity(0.7))
                        .font(.system(size: 18))
                }
                .buttonStyle(.plain)
            }
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.white.opacity(0.15))
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.white.opacity(0.2), lineWidth: 1)
                )
        )
        .frame(maxWidth: 500)
    }
}