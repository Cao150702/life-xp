import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var authVM: AuthViewModel
    @State private var showImport = false
    @State private var showClearConfirm = false
    @State private var isRegistered = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: Spacing.xl) {
                    // Profile Section
                    profileSection
                    
                    // Account Section
                    accountSection
                    
                    // Data Section
                    dataSection
                    
                    // About Section
                    aboutSection
                }
                .padding(Spacing.lg)
            }
            .background(Color.bg)
            .navigationTitle("设置")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $showImport) {
                DocumentPicker()
            }
            .alert("确认清空？", isPresented: $showClearConfirm) {
                Button("取消", role: .cancel) {}
                Button("确认清空", role: .destructive) {
                    // TODO: Clear all data
                }
            } message: {
                Text("所有数据将被永久删除，此操作不可撤销！")
            }
        }
    }
    
    // MARK: - Profile Section
    private var profileSection: some View {
        VStack(alignment: .leading, spacing: Spacing.lg) {
            HStack {
                Image(systemName: "person.crop.circle")
                    .foregroundStyle(.brandPurple)
                Text("个人资料")
                    .font(.subheadline.weight(.bold))
            }
            
            HStack {
                Text(authVM.userAvatar)
                    .font(.system(size: 48))
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(authVM.userName)
                        .font(.title3.weight(.bold))
                    Text(isRegistered ? "已注册" : "匿名用户")
                        .font(.caption)
                        .foregroundStyle(.muted)
                }
                Spacer()
            }
        }
        .padding(Spacing.xxl)
        .background(
            RoundedRectangle(cornerRadius: CornerRadius.medium)
                .fill(Color.card)
                .overlay(
                    RoundedRectangle(cornerRadius: CornerRadius.medium)
                        .stroke(Color.border, lineWidth: 1)
                )
        )
    }
    
    // MARK: - Account Section
    private var accountSection: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Image(systemName: "lock.shield")
                    .foregroundStyle(.brandBlue)
                Text("账号")
                    .font(.subheadline.weight(.bold))
            }
            .padding(.bottom, Spacing.lg)
            
            if !isRegistered {
                Button {
                    // TODO: Show registration sheet
                } label: {
                    SettingsRow(icon: "envelope", title: "注册账号", subtitle: "用邮箱或手机号升级为正式账号，支持多设备同步")
                }
                
                Divider().background(Color.border).padding(.leading, 44)
                
                Button {
                    // TODO: Phone registration
                } label: {
                    SettingsRow(icon: "phone", title: "手机号注册", subtitle: "绑定手机号后数据更安全")
                }
                
                Divider().background(Color.border).padding(.leading, 44)
            }
            
            Button {
                Task { await authVM.signOut() }
            } label: {
                SettingsRow(icon: "rectangle.portrait.and.arrow.right", title: "退出登录", subtitle: "退出后数据仍保留在云端", isDestructive: true)
            }
        }
        .padding(Spacing.xxl)
        .background(
            RoundedRectangle(cornerRadius: CornerRadius.medium)
                .fill(Color.card)
                .overlay(
                    RoundedRectangle(cornerRadius: CornerRadius.medium)
                        .stroke(Color.border, lineWidth: 1)
                )
        )
    }
    
    // MARK: - Data Section
    private var dataSection: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Image(systemName: "externaldrive")
                    .foregroundStyle(.brandEmerald)
                Text("数据管理")
                    .font(.subheadline.weight(.bold))
            }
            .padding(.bottom, Spacing.lg)
            
            Button {
                // TODO: Export data
            } label: {
                SettingsRow(icon: "square.and.arrow.up", title: "导出数据", subtitle: "导出为 JSON 文件")
            }
            
            Divider().background(Color.border).padding(.leading, 44)
            
            Button {
                showImport = true
            } label: {
                SettingsRow(icon: "square.and.arrow.down", title: "导入数据", subtitle: "从 LifeQuest Web 版导出的 JSON 文件")
            }
            
            Divider().background(Color.border).padding(.leading, 44)
            
            Button {
                showClearConfirm = true
            } label: {
                SettingsRow(icon: "trash", title: "清空数据", subtitle: "永久删除所有本地和云端数据", isDestructive: true)
            }
        }
        .padding(Spacing.xxl)
        .background(
            RoundedRectangle(cornerRadius: CornerRadius.medium)
                .fill(Color.card)
                .overlay(
                    RoundedRectangle(cornerRadius: CornerRadius.medium)
                        .stroke(Color.border, lineWidth: 1)
                )
        )
    }
    
    // MARK: - About Section
    private var aboutSection: some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            HStack {
                Image(systemName: "info.circle")
                    .foregroundStyle(.muted)
                Text("关于")
                    .font(.subheadline.weight(.bold))
            }
            
            HStack {
                Text("LifeQuest")
                    .font(.subheadline.weight(.semibold))
                Spacer()
                Text("v2.0.0")
                    .font(.caption)
                    .foregroundStyle(.muted)
            }
            .padding(.top, Spacing.sm)
        }
        .padding(Spacing.xxl)
        .background(
            RoundedRectangle(cornerRadius: CornerRadius.medium)
                .fill(Color.card)
                .overlay(
                    RoundedRectangle(cornerRadius: CornerRadius.medium)
                        .stroke(Color.border, lineWidth: 1)
                )
        )
    }
}

// MARK: - Settings Row

struct SettingsRow: View {
    let icon: String
    let title: String
    let subtitle: String
    var isDestructive: Bool = false
    
    var body: some View {
        HStack(spacing: Spacing.lg) {
            Image(systemName: icon)
                .font(.body)
                .foregroundStyle(isDestructive ? .brandRed : .textSecondary)
                .frame(width: 28)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.subheadline.weight(.medium))
                    .foregroundStyle(isDestructive ? .brandRed : .textPrimary)
                Text(subtitle)
                    .font(.caption)
                    .foregroundStyle(.muted)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundStyle(.muted)
        }
        .padding(.vertical, Spacing.md)
        .contentShape(Rectangle())
    }
}

// MARK: - Document Picker (placeholder)

struct DocumentPicker: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        let picker = UIDocumentPickerViewController(forOpeningContentTypes: [.json])
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator { Coordinator() }
    
    class Coordinator: NSObject, UIDocumentPickerDelegate {
        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            // TODO: Handle import
        }
    }
}
