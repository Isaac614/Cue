//
//  CueApp.swift
//  Cue
//
//  Created by Isaac Moore on 11/10/25.
//

import SwiftUI
import SwiftData

//@main
//struct CueApp: App {
//    var sharedModelContainer: ModelContainer = {
//        let schema = Schema([
//            Assignment.self,
//        ])
//        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
//
//        do {
//            return try ModelContainer(for: schema, configurations: [modelConfiguration])
//        } catch {
//            fatalError("Could not create ModelContainer: \(error)")
//        }
//    }()
//
//    var body: some Scene {
//        WindowGroup {
//            ListView()
//        }
//        .modelContainer(sharedModelContainer)
//    }
//}


@main
struct CueApp: App {
    var body: some Scene {
        WindowGroup {
            ListView()
        }
        .modelContainer(for: Class.self)
    }
}
