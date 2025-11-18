//
//  ClassView.swift
//  Cue
//
//  Created by Isaac Moore on 11/10/25.
//



import SwiftUI

struct ClassView: View {
    let classObject: Class
    
    var baseColor: Color {
        Color(
            red: classObject.red,
            green: classObject.green,
            blue: classObject.blue,
            opacity: classObject.opacity
        )
    }
    
    var gradientColors: [Color] {
        [baseColor.darker(by: 0), baseColor.lighter(by: 0.3)]
    }
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(classObject.assignments) { assignment in
                    NavigationLink {
                        AssignmentDetailsView(
                            assignment: assignment,
                            className: classObject.name ?? "Unnamed Class")
                    } label: {
                        AssignmentListView(assignment: assignment, classColor: baseColor)
                    }
                }
            }
            .padding()
        }
        .background(LinearGradient(
            colors: gradientColors,
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        ))
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

//import SwiftUI
//
//struct ClassView: View {
//    let classObject: Class
//    @State private var selectedAssignment: Assignment? = nil
//    @State private var pendingAssignment: Assignment? = nil
//    
//    var classColor: Color {
//            Color(
//                red: classObject.red,
//                green: classObject.green,
//                blue: classObject.blue,
//                opacity: classObject.opacity
//            )
//        }
//    
//    var body: some View {
//        ScrollView {
//            LazyVStack(spacing: 16) {
//                ForEach(classObject.assignments) { assignment in
//                    Button {
//                        pendingAssignment = assignment
//                        selectedAssignment = pendingAssignment
//                        pendingAssignment = nil
//                    } label: {
//                        AssignmentListView(assignment: assignment, classColor: classColor)
//                    }
//                    .buttonStyle(.plain)
//                }
//            }
//            .padding()
//        }
//        .background(.white)
////        .background(LinearGradient(
////            colors: [
////                Color(red: classObject.red, green: classObject.green, blue: classObject.blue),
////                Color(red: 1.0, green: 1, blue: 1)
////            ],
////            startPoint: .topLeading,
////            endPoint: .bottomTrailing
////        ))
//        .navigationTitle(classObject.name ?? "Assignments")
//        .navigationDestination(item: $selectedAssignment) { assignment in
//            AssignmentDetailsView(
//                assignment: assignment,
//                className: classObject.name ?? "Unnamed Class"
//            )
//        }
//    }
//}

#Preview {
    let classObj = Class(
        name: "Swift Dev",
        assignments: [
            Assignment(
                name: "some assignment",
                desc: "lorem ipsum dolor",
                dueDate: Date()),
            Assignment(
                name: "some assignment",
                desc: "lorem ipsum dolor",
                dueDate: Date())
        ],
        color: Color(red: 0, green: 0, blue: 0.5)
//        color: Color(red: 1, green: 0.75, blue: 0.8)
    )
    ClassView(classObject: classObj)
}

