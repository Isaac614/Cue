import SwiftUI
import SwiftData

struct ContentView: View {
    let manager = ICSManager()
    var body: some View {
        TabView {
            ListView(manager: manager)
                .tabItem {
                    Image(systemName: "leaf.fill")
                }
            
            InputView(manager: manager)
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
