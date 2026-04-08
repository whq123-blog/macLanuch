import Foundation

struct LayoutConfig: Codable {
    var columns: Int          // 每行应用数（默认 7）
    var rows: Int             // 每列应用数（默认 5）
    var iconSize: CGFloat     // 图标大小（默认 80）
    var iconSpacing: CGFloat  // 图标间距（默认 20）
    var pageIndicatorHeight: CGFloat
    var searchBarHeight: CGFloat

    static let `default` = LayoutConfig(
        columns: 7,
        rows: 5,
        iconSize: 80,
        iconSpacing: 20,
        pageIndicatorHeight: 40,
        searchBarHeight: 60
    )

    /// 每页最大应用数
    var appsPerPage: Int {
        return columns * rows
    }

    /// 网格总宽度
    var gridWidth: CGFloat {
        return CGFloat(columns) * iconSize + CGFloat(columns - 1) * iconSpacing
    }

    /// 网格总高度
    var gridHeight: CGFloat {
        return CGFloat(rows) * iconSize + CGFloat(rows - 1) * iconSpacing
    }

    /// 计算指定位置的坐标
    func positionForIndex(_ index: Int) -> CGPoint {
        let col = index % columns
        let row = index / columns

        let x = CGFloat(col) * (iconSize + iconSpacing)
        let y = CGFloat(row) * (iconSize + iconSpacing)

        return CGPoint(x: x, y: y)
    }
}