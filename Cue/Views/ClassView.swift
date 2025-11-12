//
//  ClassView.swift
//  Cue
//
//  Created by Isaac Moore on 11/10/25.
//

import SwiftUI

struct ClassView: View {
    let classObject: Class
    var body: some View {
        VStack {
            List {
                ForEach (classObject.assignments) { assignment in
                    NavigationLink {
                        AssignmentDetailsView(
                            assignment: assignment,
                            className:classObject.name)
                    } label: {
                        AssignmentListView(assignment: assignment)
                    }
                }
            }
            .navigationTitle(classObject.name ?? "unnamed class")
        }
    }
}

#Preview {
    let classObj = Class(name: "Swift Dev", assignments: [
        Assignment(
            name: "some assignment",
            desc: "lorem ipsum dolor",
            dueDate: Date()),
        Assignment(
            name: "some assignment",
            desc: "lorem ipsum dolor",
            dueDate: Date())
    ])
    ClassView(classObject: classObj)
}
