//
//  ListView.swift
//  Cue
//
//  Created by Isaac Moore on 11/10/25.
//

import SwiftUI
import SwiftData

struct ListView: View {
    let viewModel = CalendarViewModel(icsURL: nil)
    @Environment(\.modelContext) var modelContext
    @Query var classes: [Class]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 16) {
                    ForEach(classes) { classObject in
                        NavigationLink {
                            ClassView(classObject: classObject)
                        } label: {
                            ClassListView(classObject: classObject)
                        }
                    }
                }
                .padding()
            }
            .background(.white)
            .navigationTitle("Classes")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                   Button (
                    action: {
                        viewModel.icsURL = URL(string: "https://byui.instructure.com/feeds/calendars/user_MW9zKHiVd9h9cuWWsZjt5i1zHLRYUrt3wzEo4xjC.ics")
                        Task {
                            await viewModel.fetchCalendarData(context: modelContext)
                        }
                    }, label: {
                        Image(systemName: "arrow.clockwise")
                    })
                }
                ToolbarItem(placement: .topBarLeading) {
                    Button (
                        action: {
                            for classObj: Class in classes {
                                classObj.red = 1
                                classObj.green = 0.65
                                classObj.blue = 0.7
                                classObj.opacity = 1
                            }
                        }, label: {
                            Image(systemName: "paintpalette")
                        })
                }
            }
        }
    }
}

#Preview {
    ListView()
        .modelContainer(previewContainer)
}

@MainActor
let previewContainer: ModelContainer = {
    do {
        let container = try ModelContainer(
            for: Class.self, Assignment.self,
            configurations: ModelConfiguration(isStoredInMemoryOnly: true)
        )
        
        // Add sample data
        let sampleClass1 = Class(name: "Computer Science 101", color: Color(.blue))
        let assignment1 = Assignment(name: "Homework 1", desc: "Complete chapter 1 exercises", dueDate: Date().addingTimeInterval(86400))
        let assignment2 = Assignment(name: "Midterm Exam", desc: "Chapters 1-5", dueDate: Date().addingTimeInterval(172800))
        sampleClass1.addAssignment(assignment1)
        sampleClass1.addAssignment(assignment2)
        
        let sampleClass2 = Class(name: "Math 202")
        let assignment3 = Assignment(name: "Problem Set 3", desc: "Integration problems", dueDate: Date().addingTimeInterval(259200))
        sampleClass2.addAssignment(assignment3)
        
        container.mainContext.insert(sampleClass1)
        container.mainContext.insert(sampleClass2)
        
        return container
    } catch {
        fatalError("Failed to create preview container: \(error)")
    }
}()
