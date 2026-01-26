import SwiftUI

struct ClassView: View {
    @Environment(\.modelContext) var modelContext
    
    let classObject: Class
    
    var className: String {
        classObject.userName ?? classObject.originalName ?? "Unnamed Class"
    }
    
    var sortedAssignments: [Assignment] {
        classObject.assignments.filter { assignment in
            guard let dueDate = assignment.dueDate else {
                return true
            }
            
            return Calendar.current.isDateInToday(dueDate) || dueDate > Date()
        }
        .sorted { a, b in
            // Sort by due date
            guard let dateA = a.dueDate, let dateB = b.dueDate else {
                return false
            }
            if dateA != dateB {
                return dateA < dateB
            }
            
            // Fallback: sort by name
            let nameA = a.name ?? ""
            let nameB = b.name ?? ""
            return nameA < nameB
        }
    }
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(sortedAssignments) { assignment in
                    NavigationLink {
                        AssignmentDetailsView(assignment: assignment)
                    }
                    
                    
                    
                    
                    label: {
                        AssignmentListView(assignment: assignment)
                    }
                }
            }
            .padding()
        }
        .background(Color("BackgroundColor"))
        .navigationTitle(className)
        //        .background(LinearGradient(
        //            colors: gradientColors,
        //            startPoint: .topLeading,
        //            endPoint: .bottomTrailing
        //        ))
    }
}

//
//#Preview {
//    let classObj = Class(
//        name: "Swift Dev",
//        assignments: [
//            Assignment(
//                name: "some assignment",
//                desc: "lorem ipsum dolor",
//                dueDate: Date()),
//            Assignment(
//                name: "some assignment",
//                desc: "lorem ipsum dolor",
//                dueDate: Date())
//        ],
//        color: Color(red: 0, green: 0, blue: 0.5)
//    )
//    ClassView(classObject: classObj)
//}
//
