//
//  EventListView.swift
//  Cue
//
//  Created by Isaac Moore on 11/11/25.
//

import SwiftUI

struct AssignmentListView: View {
    
    let assignment: Assignment
    
    var body: some View {
        HStack {
            Button(
                action: {
                    assignment.markStatus()
                }, label: {
                    Image(systemName: assignment.isComplete ? "circle.fill" : "circle")
                        .foregroundStyle(.purple) // TODO - class.color
                })
            .buttonStyle(PlainButtonStyle())
            Spacer()
                .frame(width: 20)
            VStack(alignment: .leading) {
                Text(assignment.name ?? "there is no name for this assignment")
                    .font(.headline)
                if let formattedDate = assignment.formattedDate {
                    Text(formattedDate)
                        .foregroundColor(Color(#colorLiteral(red: 0.370555222, green: 0.3705646992, blue: 0.3705595732, alpha: 1)))
                        .font(.subheadline)
//                        .frame(height: 55)
//                        .frame(maxWidth: .infinity)
//                        .background(Color.accentColor)
//                        .cornerRadius(10)
                }
            }
        }
    }
}

#Preview {
    AssignmentListView(assignment: Assignment(
        name: "some assignment",
        desc: "lorem ipsum dolor",
        dueDate: Date())
    )
}
