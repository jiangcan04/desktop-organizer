import SwiftUI
import Foundation

#if os(macOS)
import AppKit
#endif

struct ContentView: View {
    @State private var projectZones: [ProjectZone] = []
    @State private var isShowingCreateZoneSheet = false
    @State private var newZoneName = ""
    @State private var isShowingRenameZoneSheet = false
    @State private var selectedZoneID: UUID?
    @State private var renameZoneName = ""

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
                        fileURLs: zone.fileURLs
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
                            }
                        } label: {
                            Image(systemName: "ellipsis")
                                .frame(width: 28, height: 28)
                        }
                        .menuStyle(.borderlessButton)
                        .padding(12)
                    }
                    .dropDestination(for: URL.self) { urls, _ in
                        addFiles(urls, to: zone.id)
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

        for url in fileURLs where !projectZones[index].fileURLs.contains(url) {
            projectZones[index].fileURLs.append(url)
        }

        return true
    }
}

struct ProjectZone: Identifiable {
    let id = UUID()
    var name: String
    var fileURLs: [URL] = []
}

struct ZoneView: View {
    let title: String
    let iconName: String
    let emptyMessage: String
    var fileURLs: [URL] = []

    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: iconName)
                .font(.system(size: 34))
                .foregroundStyle(Color.accentColor)

            Text(title)
                .font(.headline)

            if fileURLs.isEmpty {
                Text(emptyMessage)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            } else {
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 8) {
                        ForEach(fileURLs, id: \.self) { fileURL in
                            Button {
                                openFile(fileURL)
                            } label: {
                                HStack(spacing: 8) {
                                    Image(systemName: fileURL.hasDirectoryPath ? "folder" : "doc")
                                        .foregroundStyle(Color.accentColor)

                                    Text(fileURL.lastPathComponent)
                                        .lineLimit(1)

                                    Spacer()

                                    Image(systemName: "arrow.up.right.square")
                                        .foregroundStyle(.secondary)
                                }
                                .font(.subheadline)
                                .contentShape(Rectangle())
                            }
                            .buttonStyle(.plain)
                            .accessibilityLabel("Open \(fileURL.lastPathComponent)")
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

    private func openFile(_ fileURL: URL) {
        #if os(macOS)
        NSWorkspace.shared.open(fileURL)
        #endif
    }
}

#Preview {
    ContentView()
}
