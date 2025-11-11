//
//  ListView.swift
//  Cue
//
//  Created by Isaac Moore on 11/10/25.
//

import SwiftUI

struct ListView: View {
    @State var items: [String] = [
        "item1",
        "item2",
        "item3"
    ]
    
    var body: some View {
        NavigationStack {
            List {
                ForEach (items, id: \.self) { item in
                    NavigationLink {
                        ClassView(events: ["event1", "event2", "event3"])
                    } label: {
                        Text(item)
                    }
                }
            }
            .navigationTitle("Classes")
        }
    }
}

#Preview {
    ListView()
}
