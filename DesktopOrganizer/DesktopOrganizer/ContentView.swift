import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .top) {
                Text("Desktop Organizer")
                    .font(.largeTitle)
                    .fontWeight(.semibold)

                Spacer()

                Button {
                    // Workspace creation will be added in a later iteration.
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
                    title: "Research",
                    iconName: "folder",
                    emptyMessage: "Drop files here"
                )
                .frame(minHeight: 180)

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
            }
            .padding(.top, 24)

            Spacer()
        }
        .padding(32)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    }
}

struct ZoneView: View {
    let title: String
    let iconName: String
    let emptyMessage: String

    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: iconName)
                .font(.system(size: 34))
                .foregroundStyle(Color.accentColor)

            Text(title)
                .font(.headline)

            Text(emptyMessage)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(24)
        .background(.quaternary.opacity(0.35), in: RoundedRectangle(cornerRadius: 14))
        .overlay {
            RoundedRectangle(cornerRadius: 14)
                .stroke(.quaternary, lineWidth: 1)
        }
    }
}

#Preview {
    ContentView()
}
