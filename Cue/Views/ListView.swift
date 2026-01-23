import SwiftUI
import SwiftData

struct ListView: View {
    let viewModel: CalendarViewModel
    @Environment(\.modelContext) var modelContext
    @Query var classes: [Class]
    
    var dueAssignments: [Assignment] {
        classes
            .flatMap(\.assignments)
            .filter { a in
                a.dueDate.map { Calendar.current.isDateInToday($0) } ?? false
            }
            .sorted { a, b in
                // 1. Sort by class name first
                let classA = a.className ?? ""
                let classB = b.className ?? ""
                if classA != classB {
                    return classA < classB
                }
                
                // 2. If same class, sort by due date
                guard let dateA = a.dueDate, let dateB = b.dueDate else {
                    return false
                }
                if dateA != dateB {
                    return dateA < dateB
                }
                
                // 3. If same class and due date, sort alphabetically by name
                let nameA = a.name ?? ""
                let nameB = b.name ?? ""
                return nameA < nameB
            }
    }
    
    var upcomingAssignments: [Assignment] {
        classes
            .flatMap(\.assignments)
            .filter { a in
                guard let dueDate = a.dueDate else { return false }
                
                let today = Calendar.current.startOfDay(for: Date())
                let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: today)!
                let eightDaysFromToday = Calendar.current.date(byAdding: .day, value: 8, to: today)!
                
                return dueDate >= tomorrow && dueDate < eightDaysFromToday
            }
            .sorted { a, b in
                // 1. Sort by due date first
                guard let dateA = a.dueDate, let dateB = b.dueDate else {
                    return false
                }
                if dateA != dateB {
                    return dateA < dateB
                }
                
                // 2. If same date, sort by class name
                let classA = a.className ?? ""
                let classB = b.className ?? ""
                if classA != classB {
                    return classA < classB
                }
                
                // 3. If same date + class, sort alphabetically by name
                let nameA = a.name ?? ""
                let nameB = b.name ?? ""
                return nameA < nameB
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
                    .swipeActions {
                        Button("Delete") {
                            print("Deleted")
                        }
                        .tint(.red)
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
            .background(.white)
            .navigationTitle("Classes")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        viewModel.icsURL = URL(string: "https://byui.instructure.com/feeds/calendars/user_MW9zKHiVd9h9cuWWsZjt5i1zHLRYUrt3wzEo4xjC.ics")
                        Task { await viewModel.updateCalendar(context: modelContext) }
                    } label: {
                        Image(systemName: "arrow.clockwise")
                    }
                }
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        for classObj in classes {
                            classObj.red = 1
                            classObj.green = 0.65
                            classObj.blue = 0.7
                            classObj.opacity = 1
                        }
                    } label: {
                        Image(systemName: "paintpalette")
                    }
                }
            }
        }
    }
}

#Preview {
    ListView(viewModel: CalendarViewModel(icsURL: URL(string: "https://byui.instructure.com/feeds/calendars/user_MW9zKHiVd9h9cuWWsZjt5i1zHLRYUrt3wzEo4xjC.ics")))
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
        let sampleClass1 = Class(originalName: "Computer Science 101", color: Color(.blue))
        let assignment1 = Assignment(name: "Homework 1", desc: "Complete chapter 1 exercises dsflk sflksaj fslkfhs kfskfskfskksf skd fsk fsk", dueDate: Date(), parentClass: sampleClass1)
        let assignment2 = Assignment(name: "Midterm Exam", desc: "Chapters 1-5", dueDate: Date().addingTimeInterval(172800), parentClass: sampleClass1)
        sampleClass1.addAssignment(assignment1)
        sampleClass1.addAssignment(assignment2)
        
        let sampleClass2 = Class(originalName: "Math 202")
        let assignment3 = Assignment(name: "Problem Set 3", desc: "Integration problems", dueDate: Date().addingTimeInterval(259200), parentClass: sampleClass2)
        sampleClass2.addAssignment(assignment3)
        
        container.mainContext.insert(sampleClass1)
        container.mainContext.insert(sampleClass2)
        
        return container
    } catch {
        fatalError("Failed to create preview container: \(error)")
    }
}()
