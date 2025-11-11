//
//  EventDetailView.swift
//  Cue
//
//  Created by Isaac Moore on 11/11/25.
//

import SwiftUI
import Foundation

struct EventDetailsView: View {
    @State var eventName: String?
    @State var isComplete: Bool
    @State var description: String?
    @State var dueDate: Date
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: dueDate)
    }


    var body: some View {
        VStack {
            Text(eventName ?? "Unnamed assignment")
            Text(formattedDate)
            Text(isComplete ? "Completed" : "Not Complete")
            Spacer()
            Text(description ?? "")
            Spacer()
        }
    }
}

#Preview {
    EventDetailsView(eventName: "event 1", isComplete: false, description: "lorem ipsum dolor", dueDate: Date())
}
