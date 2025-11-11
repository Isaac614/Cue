//
//  ClassView.swift
//  Cue
//
//  Created by Isaac Moore on 11/10/25.
//

import SwiftUI

struct ClassView: View {
    @State var events: [String]
    
    @State var isComplete: Bool = true
    var body: some View {
        List {
            ForEach (events, id: \.self) { event in
                NavigationLink {
                    EventDetailsView(eventName: event, isComplete: false, description: "lorem ipsum dolor", dueDate: Date())
                } label: {
                    EventListView(isComplete: false, eventName: event)
                }
            }
        }
        .navigationTitle("Assignments")
    }
}

#Preview {
    ClassView(events: ["event1", "event2", "event3"])
}
