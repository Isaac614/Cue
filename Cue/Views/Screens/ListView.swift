import SwiftUI
import SwiftData

struct ListView: View {
    let manager: ICSManager
    @Environment(\.modelContext) var modelContext
    @Query(sort: \Class.userName, order: .forward) var classes: [Class]
    @State var swipedClass: Class? = nil
    @AppStorage("calendarURL") private var icsLink = ""
    
    var dueAssignments: [Assignment] {
        classes
            .flatMap(\.todaysAssignments)
    }

    var upcomingAssignments: [Assignment] {
           classes
               .flatMap(\.upcomingAssignments)
               .sorted { a, b in
                   if a.dueDate != b.dueDate {
                       return (a.dueDate ?? .distantPast) < (b.dueDate ?? .distantPast)
                   }
                   
                   if a.className != b.className {
                       return (a.className ?? "") < (b.className ?? "")
                   }
                   
                   return (a.name ?? "") < (b.name ?? "")
               }
       }

    
    
    var body: some View {
        NavigationStack {
            List {
                // MARK: Classes Section
                ForEach(classes) { classObject in
                    NavigationLink {
                        ClassView(classObject: classObject)
                    } label: {
                        ClassListView(classObject: classObject)
                            .padding(.horizontal)
                            .padding(.vertical, 12)
                    }
                    .listRowInsets(EdgeInsets())
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.clear)
                    .navigationLinkIndicatorVisibility(.hidden)
                    .swipeActions(edge: .trailing) {
                        Button {
                            DispatchQueue.main.async {
                                    swipedClass = classObject
                                }
                            
                        } label: {
                            Image(systemName: "paintpalette")
                        }
                        
                        Button(role: .destructive) {
                            deleteClass(classObject)
                            
                        } label: {
                            Text("Delete")
                        }
                    }
                }

                Divider()
                    .padding(.horizontal, 35)
                    .padding(.vertical, 20)
                    .listRowInsets(EdgeInsets())
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.clear)
                
                // MARK: Due Today Section
                Text("Due Today")
                    .font(.title)
                    .bold()
                    .padding(.horizontal)
                    .listRowInsets(EdgeInsets())
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.clear)
                
                if dueAssignments.isEmpty {
                    Text("You're all caught up!")
                        .font(.body)
                        .foregroundColor(Color.gray)
                        .padding(.horizontal)
                        .listRowInsets(EdgeInsets())
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.clear)
                } else {
                    ForEach(dueAssignments) { assignment in
                        NavigationLink {
                            AssignmentDetailsView(assignment: assignment)
                        } label: {
                            AssignmentListView(assignment: assignment, includeClass: true)
                                .padding(.horizontal)
                                .padding(.vertical, 9)
                        }
                        .listRowInsets(EdgeInsets())
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.clear)
                        .navigationLinkIndicatorVisibility(.hidden)
                    }
                }
                
                Divider()
                    .padding(.horizontal, 35)
                    .padding(.vertical, 35)
                    .listRowInsets(EdgeInsets())
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.clear)
                
                
                // MARK: Upcoming Section
                Text("Upcoming")
                    .font(.title)
                    .bold()
                    .padding(.horizontal)
                    .listRowInsets(EdgeInsets())
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.clear)
                
                if upcomingAssignments.isEmpty {
                    Text("You're all caught up!")
                        .font(.body)
                        .foregroundColor(Color.gray)
                        .padding(.horizontal)
                        .listRowInsets(EdgeInsets())
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.clear)
                } else {
                    ForEach(upcomingAssignments) { assignment in
                        NavigationLink {
                            AssignmentDetailsView(assignment: assignment)
                        } label: {
                            AssignmentListView(assignment: assignment, includeClass: true)
                                .padding(.horizontal)
                                .padding(.vertical, 9)
                        }
                        .listRowInsets(EdgeInsets())
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.clear)
                        .navigationLinkIndicatorVisibility(.hidden)
                    }
                }
            }
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
            .background(Color("BackgroundColor"))
            .foregroundStyle(Color("TextColor"))
            .navigationTitle("Classes")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        Task { await manager.updateCalendar(context: modelContext, icsURL: icsLink) }
                    } label: {
                        Image(systemName: "arrow.clockwise")
                    }
                }
            }
        }
        .sheet(item: $swipedClass) { classToEdit in
            ClassColorPicker(classObject: classToEdit)
        }
    }
    
    
    private func deleteClass(_ classItem: Class) {
            // Remove from context
            modelContext.delete(classItem)
            
            // Save changes
            do {
                try modelContext.save()
            } catch {
                print("Failed to delete class: \(error)")
            }
        }
}

#Preview {
    ListView(manager: ICSManager())
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
        let sampleClass1 = Class(id: UUID(), originalName: "Computer Science 101", color: Color(.blue))
        let assignment1 = Assignment(icsUID: "12", name: "Homework 1", desc: "Complete chapter 1 exercises dsflk sflksaj fslkfhs kfskfskfskksf skd fsk fsk", dueDate: Date(), parentClass: sampleClass1)
        let assignment2 = Assignment(icsUID: "34", name: "Midterm Exam", desc: "Chapters 1-5", dueDate: Date().addingTimeInterval(172800), parentClass: sampleClass1)
        sampleClass1.addAssignment(assignment1)
        sampleClass1.addAssignment(assignment2)
        
        let sampleClass2 = Class(id: UUID(), originalName: "Math 202")
        let assignment3 = Assignment(icsUID: "78", name: "Problem Set 3", desc: "Integration problems", dueDate: Date().addingTimeInterval(259200), parentClass: sampleClass2)
        sampleClass2.addAssignment(assignment3)
        
        container.mainContext.insert(sampleClass1)
        container.mainContext.insert(sampleClass2)
        
        return container
    } catch {
        fatalError("Failed to create preview container: \(error)")
    }
}()
