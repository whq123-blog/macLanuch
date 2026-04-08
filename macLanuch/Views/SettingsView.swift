import SwiftUI

/// 设置视图
struct SettingsView: View {
    @ObservedObject var viewModel: SettingsViewModel
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack(spacing: 30) {
            // 标题
            Text("Settings")
                .font(.system(size: 28, weight: .bold))

            // 快捷键设置
            VStack(alignment: .leading, spacing: 15) {
                Text("Keyboard Shortcut")
                    .font(.system(size: 18, weight: .semibold))

                HStack {
                    Text("Toggle Launchpad:")
                        .font(.system(size: 14))

                    TextField("Shortcut", text: $viewModel.shortcutDisplay)
                        .textFieldStyle(.roundedBorder)
                        .frame(width: 150)
                        .disabled(true)

                    Button("Change") {
                        // 打开快捷键选择界面（稍后实现）
                        viewModel.isEditingShortcut = true
                    }
                    .buttonStyle(.bordered)
                }

                Toggle("Enable global shortcut", isOn: $viewModel.shortcutEnabled)
                    .font(.system(size: 14))
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(10)

            // 布局设置
            VStack(alignment: .leading, spacing: 15) {
                Text("Layout Settings")
                    .font(.system(size: 18, weight: .semibold))

                HStack {
                    Text("Columns:")
                        .font(.system(size: 14))

                    Stepper(
                        value: $viewModel.columns,
                        in: 4...10
                    ) {
                        Text("\(viewModel.columns)")
                    }
                }

                HStack {
                    Text("Rows:")
                        .font(.system(size: 14))

                    Stepper(
                        value: $viewModel.rows,
                        in: 3...8
                    ) {
                        Text("\(viewModel.rows)")
                    }
                }

                HStack {
                    Text("Icon Size:")
                        .font(.system(size: 14))

                    Slider(value: $viewModel.iconSize, in: 60...120, step: 5)
                    Text("\(Int(viewModel.iconSize))")
                }
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(10)

            // 显示选项
            VStack(alignment: .leading, spacing: 15) {
                Text("Display Options")
                    .font(.system(size: 18, weight: .semibold))

                Toggle("Show system apps", isOn: $viewModel.showSystemApps)
                    .font(.system(size: 14))

                Toggle("Show in Dock", isOn: $viewModel.showInDock)
                    .font(.system(size: 14))

                Toggle("Auto-arrange apps", isOn: $viewModel.autoArrange)
                    .font(.system(size: 14))
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(10)

            // 按钮
            HStack(spacing: 20) {
                Button("Cancel") {
                    dismiss()
                }
                .buttonStyle(.bordered)

                Button("Save") {
                    viewModel.saveSettings()
                    dismiss()
                }
                .buttonStyle(.borderedProminent)
            }

            Spacer()
        }
        .padding(40)
        .frame(width: 500, height: 600)
    }
}