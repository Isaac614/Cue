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
//            StopwatchView()
//                .tabItem {
//                    Image(systemName: "stopwatch.fill")
//                    Text("Stopwatch")
//                }
//            
//            TimersView()
//                .tabItem {
//                    Image(systemName: "timer")
//                    Text("Timers")
//                }
        }
        .accentColor(Color("AccentColor")) // Tab bar tint color
    }
}

// Example views
struct WorldClockView: View {
    var body: some View {
        NavigationView {
            Text("World Clock")
                .navigationTitle("World Clock")
        }
    }
}

struct AlarmsView: View {
    var body: some View {
        NavigationView {
            Text("Alarms")
                .navigationTitle("Alarms")
        }
    }
}

struct StopwatchView: View {
    var body: some View {
        Text("Stopwatch")
    }
}

struct TimersView: View {
    var body: some View {
        Text("Timers")
    }
}


#Preview {
    ContentView()
        .modelContainer(previewContainer)
}
