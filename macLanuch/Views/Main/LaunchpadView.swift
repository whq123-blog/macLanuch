import SwiftUI

/// 主启动台视图
struct LaunchpadView: View {
    @StateObject private var viewModel = LaunchpadViewModel()

    var body: some View {
        ZStack {
            // 背景模糊层（点击关闭）
            BackgroundBlurView()
                .ignoresSafeArea()
                .onTapGesture {
                    dismissLaunchpad()
                }

            VStack(spacing: 0) {
                Spacer(minLength: 60)

                // 搜索栏和编辑按钮
                HStack {
                    SearchBarView(text: $viewModel.searchText)

                    // 编辑按钮
                    Button(action: {
                        viewModel.toggleEditMode()
                    }) {
                        Image(systemName: viewModel.isEditing ? "checkmark.circle.fill" : "slider.horizontal.3")
                            .font(.system(size: 20))
                            .foregroundColor(.white.opacity(0.8))
                    }
                    .buttonStyle(.plain)
                    .padding(.leading, 10)
                }
                .padding(.horizontal)

                Spacer(minLength: 40)

                // 应用网格
                if viewModel.searchText.isEmpty {
                    // 正常分页视图
                    if viewModel.isLoading {
                        ProgressView()
                            .scaleEffect(1.5)
                            .progressViewStyle(.automatic)
                    } else {
                        TabView(selection: $viewModel.currentPage) {
                            ForEach(viewModel.pages.indices, id: \.self) { index in
                                AppGridView(
                                    apps: viewModel.pages[index].apps,
                                    isEditing: $viewModel.isEditing,
                                    onAppTap: { app in
                                        viewModel.launchApp(app)
                                    },
                                    onAppDelete: { app in
                                        viewModel.deleteApp(app)
                                    },
                                    onAppMove: { from, to in
                                        viewModel.moveApp(fromPosition: from, toPosition: to, onPage: index)
                                    },
                                    onCreateFolder: { app1, app2 in
                                        // 在当前位置创建文件夹
                                        viewModel.createFolder(with: app1, and: app2, at: index, position: 0)
                                    }
                                )
                                .tag(index)
                            }
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                } else {
                    // 搜索结果视图
                    if viewModel.filteredApps.isEmpty {
                        VStack(spacing: 20) {
                            Image(systemName: "magnifyingglass")
                                .font(.system(size: 48))
                                .foregroundColor(.gray)

                            Text("No apps found")
                                .font(.system(size: 18))
                                .foregroundColor(.gray)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else {
                        ScrollView {
                            LazyVGrid(
                                columns: Array(
                                    repeating: GridItem(.fixed(100), spacing: 20),
                                    count: LayoutConfig.default.columns
                                ),
                                spacing: LayoutConfig.default.iconSpacing
                            ) {
                                ForEach(viewModel.filteredApps) { app in
                                    AppIconView(
                                        app: app,
                                        isEditing: $viewModel.isEditing,
                                        onTap: { viewModel.launchApp(app) },
                                        onDelete: nil,
                                        onDragStart: nil,
                                        onDragEnd: nil
                                    )
                                }
                            }
                            .padding()
                        }
                    }
                }

                // 页面指示器
                if viewModel.searchText.isEmpty && viewModel.pages.count > 1 {
                    PageIndicatorView(
                        totalPages: viewModel.pages.count,
                        currentPage: $viewModel.currentPage
                    )
                    .padding(.vertical, 20)
                }

                Spacer()
            }
        }
        .onExitCommand {
            // 按 Esc 键关闭
            dismissLaunchpad()
        }
    }

    /// 关闭启动台
    private func dismissLaunchpad() {
        WindowManagerService.shared.hide()
    }
}