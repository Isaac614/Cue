import SwiftUI

struct ClassView: View {
    @Environment(\.modelContext) var modelContext
    
    let classObject: Class
    
    var classColor: Color? {
        guard let r = classObject.red,
              let g = classObject.green,
              let b = classObject.blue else {
            return nil
        }
        
        return Color(red: r, green: g, blue: b)
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
    
//    var gradientColors: [Color] {
//        guard let base = classColor else {
//            return [Color(.pink).darker(by: 0), Color(.pink).lighter(by: 0.3)]
//        }
//        
//        return [base.darker(by: 0), base.lighter(by: 0.3)]
//    }
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(sortedAssignments) { assignment in
                    NavigationLink {
                        AssignmentDetailsView(assignment: assignment)
                    } label: {
                        AssignmentListView(assignment: assignment)
                    }
                }
            }
            .padding()
        }
//        .background(LinearGradient(
//            colors: gradientColors,
//            startPoint: .topLeading,
//            endPoint: .bottomTrailing
//        ))
        .navigationTitle(classObject.name ?? "Assignments")
    }
}

extension Color {
    func lighter(by percentage: Double = 0.3) -> Color {
        return self.adjust(by: abs(percentage))
    }
    
    func darker(by percentage: Double = 0.3) -> Color {
        return self.adjust(by: -abs(percentage))
    }
    
    private func adjust(by percentage: Double) -> Color {
        #if canImport(UIKit)
        guard let components = UIColor(self).cgColor.components else { return self }
        #elseif canImport(AppKit)
        guard let components = NSColor(self).cgColor.components else { return self }
        #endif
        
        return Color(
            red: min(max(components[0] + percentage, 0), 1),
            green: min(max(components[1] + percentage, 0), 1),
            blue: min(max(components[2] + percentage, 0), 1),
            opacity: components.count > 3 ? components[3] : 1
        )
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
