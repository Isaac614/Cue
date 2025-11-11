//
//  EventListView.swift
//  Cue
//
//  Created by Isaac Moore on 11/11/25.
//

import SwiftUI

struct EventListView: View {
    @State var isComplete: Bool = false;
    @State var eventName: String?
    
    var body: some View {
        HStack {
            Button(
                action: {
                    isComplete = !isComplete
                }, label: {
                    Image(systemName: isComplete ? "circle.fill" : "circle")
                        .foregroundStyle(.purple) // TODO - class.color
                }
            )
            .buttonStyle(PlainButtonStyle())
            Spacer()
                .frame(width: 20)
            Text(eventName ?? "there is no name for this assignment")
        }
    }
}

#Preview {
    EventListView()
}
