import Foundation

/// 常量定义
struct Constants {
    // MARK: - Bundle
    static let bundleIdentifier = "com.macLaunch"

    // MARK: - UserDefaults Keys
    static let userLayoutKey = "com.macLaunch.userLayout"
    static let settingsKey = "com.macLaunch.settings"

    // MARK: - Animation
    static let defaultAnimationDuration = 0.3
    static let fastAnimationDuration = 0.2
    static let wiggleAnimationSpeed = 15.0
    static let wiggleAnimationAngle = 2.0

    // MARK: - Layout
    static let defaultColumns = 7
    static let defaultRows = 5
    static let defaultIconSize = 80.0
    static let defaultIconSpacing = 20.0

    // MARK: - Application Paths
    static let applicationPaths = [
        "/Applications",
        "/System/Applications",
        "/System/Applications/Utilities",
        "/Applications/Utilities"
    ]
}