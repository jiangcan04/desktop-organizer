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

            Spacer()
        }
        .padding(32)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    }
}

#Preview {
    ContentView()
}
