import AppKit

/// 应用图标缓存
class IconCache {
    static let shared = IconCache()

    private var cache = NSCache<NSString, NSImage>()
    private let lock = NSLock()

    private init() {
        cache.countLimit = 200  // 最多缓存 200 个图标
        cache.totalCostLimit = 50 * 1024 * 1024  // 50MB 内存限制
    }

    /// 获取缓存图标
    func get(for appId: String) -> NSImage? {
        lock.lock()
        let image = cache.object(forKey: appId as NSString)
        lock.unlock()
        return image
    }

    /// 设置缓存图标
    func set(_ image: NSImage, for appId: String) {
        lock.lock()
        // 计算图标大小作为 cost
        let cost = Int(image.size.width * image.size.height * 4)  // 假设每个像素 4 字节
        cache.setObject(image, forKey: appId as NSString, cost: cost)
        lock.unlock()
    }

    /// 清除缓存
    func clear() {
        lock.lock()
        cache.removeAllObjects()
        lock.unlock()
    }

    /// 移除特定图标
    func remove(for appId: String) {
        lock.lock()
        cache.removeObject(forKey: appId as NSString)
        lock.unlock()
    }
}