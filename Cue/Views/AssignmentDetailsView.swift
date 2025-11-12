//
//  EventDetailView.swift
//  Cue
//
//  Created by Isaac Moore on 11/11/25.
//

import SwiftUI
import Foundation

struct AssignmentDetailsView: View {
    let assignment: Assignment
    let className: String?
    
    var completionStatus: String?  {
        guard let dueDate = assignment.dueDate else { return nil }
        
        let now = Date()
        return assignment.isComplete ?
        (now <= dueDate ? "Complete" : "Submitted Late") :
        (now <= dueDate ? "Not Complete" : "Overdue")
    }
    
    let softRedGradient = LinearGradient(
        colors: [
            Color(red: 0.90, green: 0.5, blue: 0.5),
            Color(red: 1.0, green: 0.65, blue: 0.7)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    // Soft green/blue gradient
    let softGreenGradient = LinearGradient(
        colors: [
            Color(red: 0.6, green: 1, blue: 0.6),
            Color(red: 0.5, green: 1.0, blue: 0.8)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    var body: some View {
        ZStack(alignment: .bottom) {
            ScrollView {
                VStack (alignment: .leading) {
                    VStack (alignment: .leading) {
                        Text(assignment.name ?? "Unnamed assignment")
                            .font(.largeTitle)
                            .bold()
                        
                        if let completionStatus = completionStatus {
                            Text(completionStatus)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 8)
                                .background(
                                    Capsule()
                                        .fill(completionStatus == "Complete" ? softGreenGradient : softRedGradient))
                                .font(.body)
                                .offset(y: -16)
                                .padding(.bottom, -16)
                                .padding(.vertical, 5)
                        }
                        
                        
                        if let formattedDate = assignment.formattedDate {
                            Text("Due Date")
                                .foregroundStyle(Color(.darkGray))
                                .padding(.bottom, 2)
                            Text(formattedDate)
                        }
                    }
                    .padding()
                    .frame(
                        maxWidth: .infinity,
                        alignment: .leading)
                    .background(Color(.systemBackground))
                    .cornerRadius(12)
                    .shadow(
                        color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
                    .padding(.bottom)
                    
                    
                    if let desc = assignment.desc {
                        VStack (alignment: .leading, spacing: 10) {
                            Text("Description")
                                .foregroundStyle(Color(.darkGray))
                            Text(desc)
                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color(.systemBackground))
                        .cornerRadius(12)
                        .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
                        .padding(.bottom)
                    }
                }
                .padding(.horizontal, 23)
                .padding(.top, 23)
                .padding(.bottom, 120) // Add space at bottom for button
            }
            
            // Gradient fade overlay
            VStack {
                Spacer()
                LinearGradient(
                    colors: [
                        Color(.systemBackground).opacity(0.2),
                        Color(.systemBackground).opacity(1),
                        Color(.systemBackground)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(height: 200)
                .allowsHitTesting(false) // Allow taps to pass through
                .offset(y: 40)
            }
            
            // Button at bottom
            VStack {
                Button (
                    action: {
                        withAnimation {
                            assignment.markStatus()
                        }
                    }, label: {
                        Text(!assignment.isComplete ? "Mark as Completed" : "Mark as Incomplete")
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .frame(height: 80)
                            .frame(maxWidth: .infinity)
                            .background(
                                Capsule()
                                    .fill(softGreenGradient))
                            .font(.title3)
                            .bold()
                            .foregroundStyle(Color.black)
                    })
                .padding(.horizontal, 23)
                .padding(.bottom, -10)
            }
        }
        .fontDesign(.rounded)
        .frame(
            maxWidth: .infinity,
            maxHeight: .infinity,
            alignment: .leading)
    }
}

#Preview {
    AssignmentDetailsView (
        assignment: Assignment(
            name: "10A Class Activity Trend Lines Practice",
            desc: "Download the class activity template:  Lesson 10A Trendlines Practice Class ActivityDownload Lesson 10A Trendlines Practice Class Activity\n\nOnce you have completed the class activity, please upload your completed assignment to this Dropbox by the deadline.",
            dueDate: Date(), isComplete: false),
        className: "Math"
    )
}
