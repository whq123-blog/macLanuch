import SwiftUI

/// 抖动动画修饰符（编辑模式）
struct WiggleAnimation: ViewModifier {
    @State private var angle: Double = 0
    let isWiggling: Bool

    func body(content: Content) -> some View {
        content
            .rotationEffect(.degrees(angle))
            .onAppear {
                if isWiggling {
                    startWiggling()
                }
            }
            .onChange(of: isWiggling) { newValue in
                if newValue {
                    startWiggling()
                } else {
                    stopWiggling()
                }
            }
    }

    private func startWiggling() {
        withAnimation(
            Animation.easeInOut(duration: 0.15)
                .repeatForever(autoreverses: true)
        ) {
            angle = Constants.wiggleAnimationAngle
        }
    }

    private func stopWiggling() {
        withAnimation(.easeOut(duration: 0.1)) {
            angle = 0
        }
    }
}

extension View {
    /// 应用抖动动画
    func wiggle(isWiggling: Bool) -> some View {
        modifier(WiggleAnimation(isWiggling: isWiggling))
    }
}