//
//  CueApp.swift
//  Cue
//
//  Created by Isaac Moore on 11/10/25.
//

import SwiftUI
import SwiftData

@main
struct CueApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Class.self)
    }
}
