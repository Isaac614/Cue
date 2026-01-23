import SwiftUI
import SwiftData

struct ContentView: View {
    let viewModel = CalendarViewModel(icsURL: nil)
    var body: some View {
        TabView {
            ListView(viewModel: viewModel)
                .tabItem {
                    Image(systemName: "leaf.fill")
                }
            
            InputView(viewModel: viewModel)
                .tabItem {
                    Image(systemName: "plus.app.fill")
                }
        }
        .accentColor(Color("AccentColor")) // Tab bar tint color
    }
}

#Preview {
    ContentView()
        .modelContainer(previewContainer)
}
