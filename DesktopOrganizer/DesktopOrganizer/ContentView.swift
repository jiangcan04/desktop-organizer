import SwiftUI
import Foundation

#if os(macOS)
import AppKit
#endif

struct ContentView: View {
    @State private var projectZones: [ProjectZone]
    @State private var isShowingCreateZoneSheet = false
    @State private var newZoneName = ""
    @State private var isShowingRenameZoneSheet = false
    @State private var selectedZoneID: UUID?
    @State private var renameZoneName = ""

    private static let projectZonesStorageKey = "projectZones"

    init() {
        _projectZones = State(initialValue: Self.loadProjectZones())
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .top) {
                Text("Desktop Organizer")
                    .font(.largeTitle)
                    .fontWeight(.semibold)

                Spacer()

                Button {
                    newZoneName = ""
                    isShowingCreateZoneSheet = true
                } label: {
                    Image(systemName: "plus")
                        .font(.title3.weight(.semibold))
                        .frame(width: 32, height: 32)
                }
                .buttonStyle(.borderedProminent)
                .accessibilityLabel("Add workspace")
            }

            Text("My Workspace")
                .font(.title2)
                .fontWeight(.medium)
                .foregroundStyle(.secondary)
                .padding(.top, 12)

            LazyVGrid(
                columns: [
                    GridItem(.flexible(), spacing: 20),
                    GridItem(.flexible(), spacing: 20)
                ],
                alignment: .leading,
                spacing: 20
            ) {
                ZoneView(
                    title: "Screenshots",
                    iconName: "photo",
                    emptyMessage: "Drop images here"
                )
                .frame(minHeight: 180)

                ZoneView(
                    title: "Inbox",
                    iconName: "tray",
                    emptyMessage: "Drop files here"
                )
                .frame(minHeight: 180)

                ForEach(projectZones) { zone in
                    ZoneView(
                        title: zone.name,
                        iconName: "folder",
                        emptyMessage: "Drop files here",
                        files: zone.files,
                        onRemoveFile: { file in
                            removeFile(file, from: zone.id)
                        }
                    )
                    .overlay(alignment: .topTrailing) {
                        Menu {
                            Button("Rename") {
                                selectedZoneID = zone.id
                                renameZoneName = zone.name
                                isShowingRenameZoneSheet = true
                            }

                            Button("Delete", role: .destructive) {
                                projectZones.removeAll { $0.id == zone.id }
                                saveProjectZones()
                            }
                        } label: {
                            Image(systemName: "ellipsis")
                                .frame(width: 28, height: 28)
                        }
                        .menuStyle(.borderlessButton)
                        .padding(12)
                    }
                    .dropDestination(for: URL.self) { urls, _ in
                        _ = addFiles(urls, to: zone.id)
                    }
                    .frame(minHeight: 180)
                }
            }
            .padding(.top, 24)

            Spacer()
        }
        .padding(32)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .sheet(isPresented: $isShowingCreateZoneSheet) {
            VStack(alignment: .leading, spacing: 20) {
                Text("Create Project Zone")
                    .font(.title2)
                    .fontWeight(.semibold)

                TextField("Zone name", text: $newZoneName)
                    .textFieldStyle(.roundedBorder)

                HStack {
                    Spacer()

                    Button("Cancel") {
                        isShowingCreateZoneSheet = false
                    }

                    Button("Create") {
                        let name = newZoneName.trimmingCharacters(in: .whitespacesAndNewlines)
                        guard !name.isEmpty else { return }

                        projectZones.append(ProjectZone(name: name))
                        saveProjectZones()
                        isShowingCreateZoneSheet = false
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(newZoneName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
            .padding(24)
            .frame(width: 360)
        }
        .sheet(isPresented: $isShowingRenameZoneSheet) {
            VStack(alignment: .leading, spacing: 20) {
                Text("Rename Project Zone")
                    .font(.title2)
                    .fontWeight(.semibold)

                TextField("Zone name", text: $renameZoneName)
                    .textFieldStyle(.roundedBorder)

                HStack {
                    Spacer()

                    Button("Cancel") {
                        isShowingRenameZoneSheet = false
                    }

                    Button("Save") {
                        let name = renameZoneName.trimmingCharacters(in: .whitespacesAndNewlines)
                        guard let selectedZoneID = selectedZoneID, !name.isEmpty else { return }

                        if let index = projectZones.firstIndex(where: { $0.id == selectedZoneID }) {
                            projectZones[index].name = name
                            saveProjectZones()
                        }

                        isShowingRenameZoneSheet = false
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(renameZoneName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
            .padding(24)
            .frame(width: 360)
        }
    }

    private func addFiles(_ urls: [URL], to zoneID: UUID) -> Bool {
        guard let index = projectZones.firstIndex(where: { $0.id == zoneID }) else {
            return false
        }

        let fileURLs = urls.filter(\.isFileURL)
        guard !fileURLs.isEmpty else { return false }

        var didAddFiles = false
        for url in fileURLs {
            guard let file = ProjectFile(fileURL: url),
                  !projectZones[index].files.contains(where: { $0.fileURL == file.fileURL }) else {
                continue
            }

            projectZones[index].files.append(file)
            didAddFiles = true
        }

        if didAddFiles {
            saveProjectZones()
        }

        return didAddFiles
    }

    private func removeFile(_ file: ProjectFile, from zoneID: UUID) {
        guard let index = projectZones.firstIndex(where: { $0.id == zoneID }) else {
            return
        }

        projectZones[index].files.removeAll { $0.id == file.id }
        saveProjectZones()
    }

    private nonisolated static func loadProjectZones() -> [ProjectZone] {
        guard let data = UserDefaults.standard.data(forKey: projectZonesStorageKey),
              let zones = try? JSONDecoder().decode([ProjectZone].self, from: data) else {
            return []
        }

        let restoredZones = zones.map(Self.restoreFiles)

        if let refreshedData = try? JSONEncoder().encode(restoredZones) {
            UserDefaults.standard.set(refreshedData, forKey: projectZonesStorageKey)
        }

        return restoredZones
    }

    private func saveProjectZones() {
        guard let data = try? JSONEncoder().encode(projectZones) else { return }

        UserDefaults.standard.set(data, forKey: Self.projectZonesStorageKey)
    }

    private nonisolated static func restoreFiles(in zone: ProjectZone) -> ProjectZone {
        var restoredZone = zone
        restoredZone.files = zone.files.map(ProjectFile.restoringBookmark)
        return restoredZone
    }
}

struct ProjectZone: Identifiable, Codable {
    let id: UUID
    var name: String
    var files: [ProjectFile] = []

    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case files
    }

    init(id: UUID = UUID(), name: String) {
        self.id = id
        self.name = name
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        files = try container.decodeIfPresent([ProjectFile].self, forKey: .files) ?? []
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(files, forKey: .files)
    }
}

struct ProjectFile: Identifiable, Codable {
    let id: UUID
    let name: String
    var bookmarkData: Data
    var fileURL: URL?

    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case bookmarkData
    }

    init?(fileURL: URL) {
        #if os(macOS)
        let didStartAccessing = fileURL.startAccessingSecurityScopedResource()
        defer {
            if didStartAccessing {
                fileURL.stopAccessingSecurityScopedResource()
            }
        }

        guard let bookmarkData = try? fileURL.bookmarkData(
            options: .withSecurityScope,
            includingResourceValuesForKeys: nil,
            relativeTo: nil
        ) else {
            return nil
        }

        id = UUID()
        name = fileURL.lastPathComponent
        self.bookmarkData = bookmarkData
        self.fileURL = fileURL
        #else
        return nil
        #endif
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        bookmarkData = try container.decode(Data.self, forKey: .bookmarkData)
        fileURL = nil
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(bookmarkData, forKey: .bookmarkData)
    }

    nonisolated static func restoringBookmark(_ file: ProjectFile) -> ProjectFile {
        #if os(macOS)
        var restoredFile = file
        var isStale = false

        guard let resolvedURL = try? URL(
            resolvingBookmarkData: file.bookmarkData,
            options: [.withSecurityScope, .withoutUI],
            relativeTo: nil,
            bookmarkDataIsStale: &isStale
        ) else {
            return restoredFile
        }

        restoredFile.fileURL = resolvedURL

        if isStale {
            let didStartAccessing = resolvedURL.startAccessingSecurityScopedResource()
            defer {
                if didStartAccessing {
                    resolvedURL.stopAccessingSecurityScopedResource()
                }
            }

            if let refreshedBookmarkData = try? resolvedURL.bookmarkData(
                options: .withSecurityScope,
                includingResourceValuesForKeys: nil,
                relativeTo: nil
            ) {
                restoredFile.bookmarkData = refreshedBookmarkData
            }
        }

        return restoredFile
        #else
        return file
        #endif
    }
}

struct ZoneView: View {
    let title: String
    let iconName: String
    let emptyMessage: String
    var files: [ProjectFile] = []
    var onRemoveFile: ((ProjectFile) -> Void)?

    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: iconName)
                .font(.system(size: 34))
                .foregroundStyle(Color.accentColor)

            Text(title)
                .font(.headline)

            if files.isEmpty {
                Text(emptyMessage)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            } else {
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 8) {
                        ForEach(files) { file in
                            Button {
                                openFile(file)
                            } label: {
                                HStack(spacing: 8) {
                                    Image(systemName: file.fileURL?.hasDirectoryPath == true ? "folder" : "doc")
                                        .foregroundStyle(Color.accentColor)

                                    Text(file.name)
                                        .lineLimit(1)

                                    Spacer()

                                    Image(systemName: "arrow.up.right.square")
                                        .foregroundStyle(.secondary)
                                }
                                .font(.subheadline)
                                .contentShape(Rectangle())
                            }
                            .buttonStyle(.plain)
                            .disabled(file.fileURL == nil)
                            .accessibilityLabel("Open \(file.name)")
                            .contextMenu {
                                if let onRemoveFile {
                                    Button("Remove from Zone", role: .destructive) {
                                        onRemoveFile(file)
                                    }
                                }
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .frame(maxHeight: 96)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(24)
        .background(.quaternary.opacity(0.35), in: RoundedRectangle(cornerRadius: 14))
        .overlay {
            RoundedRectangle(cornerRadius: 14)
                .stroke(.quaternary, lineWidth: 1)
        }
    }

    private func openFile(_ file: ProjectFile) {
        #if os(macOS)
        guard let fileURL = file.fileURL else { return }

        let didStartAccessing = fileURL.startAccessingSecurityScopedResource()
        defer {
            if didStartAccessing {
                fileURL.stopAccessingSecurityScopedResource()
            }
        }

        NSWorkspace.shared.open(fileURL)
        #endif
    }
}

#Preview {
    ContentView()
}
