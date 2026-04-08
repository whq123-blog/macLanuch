import Foundation
import Carbon
import AppKit

/// 全局快捷键服务
class GlobalShortcutService {
    static let shared = GlobalShortcutService()

    private var hotKeyRef: EventHotKeyRef?
    private var hotKeyID: EventHotKeyID?
    private var callback: (() -> Void)?
    private var eventHandler: EventHandlerRef?

    private init() {
        setupEventHandler()
    }

    deinit {
        unregister()
        if let handler = eventHandler {
            RemoveEventHandler(handler)
        }
    }

    /// 注册全局快捷键
    func register(
        keyCode: UInt32,
        modifiers: UInt32,
        callback: @escaping () -> Void
    ) -> Bool {
        self.callback = callback

        var hotKeyID = EventHotKeyID()
        hotKeyID.id = 1
        hotKeyID.signature = OSType(0x4C41554E) // "LAUN"

        let status = RegisterEventHotKey(
            keyCode,
            modifiers,
            hotKeyID,
            GetEventDispatcherTarget(),
            0,
            &hotKeyRef
        )

        if status == noErr {
            print("Global shortcut registered successfully")
            return true
        } else {
            print("Failed to register global shortcut: \(status)")
            return false
        }
    }

    /// 注册默认快捷键 (Cmd+Space)
    func registerDefaultShortcut(callback: @escaping () -> Void) {
        let modifiers: UInt32 = UInt32(cmdKey)
        let keyCode: UInt32 = 49  // Space 键

        if register(keyCode: keyCode, modifiers: modifiers, callback: callback) {
            print("Cmd+Space shortcut registered")
        } else {
            print("Failed to register Cmd+Space shortcut, may conflict with Spotlight")
        }
    }

    /// 注销快捷键
    func unregister() {
        if let ref = hotKeyRef {
            UnregisterEventHotKey(ref)
            hotKeyRef = nil
            print("Global shortcut unregistered")
        }
    }

    /// 设置事件处理器
    private func setupEventHandler() {
        var eventType = EventTypeSpec(
            eventClass: OSType(kEventClassKeyboard),
            eventKind: OSType(kEventHotKeyPressed)
        )

        InstallEventHandler(
            GetEventDispatcherTarget(),
            { (_, event, _) -> OSStatus in
                GlobalShortcutService.shared.handleHotKeyEvent(event)
                return noErr
            },
            1,
            &eventType,
            nil,
            &eventHandler
        )
    }

    /// 处理热键事件
    private func handleHotKeyEvent(_ event: EventRef?) {
        print("Hot key pressed!")
        callback?()
    }
}

/// 快捷键常量
extension GlobalShortcutService {
    struct ShortcutKey {
        static let space: UInt32 = 49
        static let returnKey: UInt32 = 36
        static let escape: UInt32 = 53

        static let cmd: UInt32 = UInt32(cmdKey)
        static let option: UInt32 = UInt32(optionKey)
        static let control: UInt32 = UInt32(controlKey)
        static let shift: UInt32 = UInt32(shiftKey)
    }
}