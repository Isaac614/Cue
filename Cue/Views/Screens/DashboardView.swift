import SwiftUI
import SwiftData

struct DashboardView: View {
    let manager: ICSManager
    @Environment(\.modelContext) var modelContext
    @AppStorage("calendarURL") private var icsLink = ""
    @State private var swipedClass: Class? = nil
    
    
    var body: some View {
        NavigationStack {
            ScrollView {
                ClassCarousal(manager: manager, swipedClass: $swipedClass)
                DueToday()
                UpcomingAssignments()
            }
            .padding(.horizontal)
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
            .background(Color("BackgroundColor"))
            .foregroundStyle(Color("TextColor"))
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        Task { await manager.updateCalendar(context: modelContext, icsURL: icsLink) }
                    } label: {
                        Image(systemName: "arrow.clockwise")
                    }
                }
            }
            .sheet(item: $swipedClass) { classToEdit in
                ClassColorPicker(classObject: classToEdit)
            }
        }
    }
}

#Preview {
    DashboardView(manager: ICSManager())
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
