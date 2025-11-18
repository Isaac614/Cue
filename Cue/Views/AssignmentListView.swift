//
//  EventListView.swift
//  Cue
//
//  Created by Isaac Moore on 11/11/25.
//

import SwiftUI


//struct AssignmentListView: View {
//    
//    let assignment: Assignment
//    let classColor: Color? // Add this to receive the class color
//    
//    var gradientColors: [Color] {
//        guard let baseColor = classColor else {
//            // Default gradient if no color provided
//            return [Color.gray.opacity(0.1), Color.gray.opacity(0.05)]
//        }
//        return [baseColor.darker(by: 0.1).opacity(0.2), baseColor.lighter(by: 0.1).opacity(0.15)]
//    }
//    
//    var body: some View {
//        HStack {
//            Button(
//                action: {
//                    assignment.markStatus()
//                }, label: {
//                    Image(systemName: assignment.isComplete ? "circle.fill" : "circle")
//                        .foregroundStyle(.black)
//                })
//            .buttonStyle(PlainButtonStyle())
//            Spacer()
//                .frame(width: 20)
//            HStack {
//                VStack(alignment: .leading) {
//                    Text(assignment.name ?? "there is no name for this assignment")
//                        .font(.headline)
//                    if let formattedDate = assignment.formattedDate {
//                        Text(formattedDate)
//                            .foregroundColor(Color(red: 0.37, green: 0.37, blue: 0.37))
//                            .font(.subheadline)
//                    }
//                }
//                Spacer()
//                Image(systemName: "chevron.right")
//                    .font(.title2)
//                    .bold()
//            }
//        }
//        .padding()
//        .frame(maxWidth: .infinity, alignment: .leading)
////        .glassEffect(.clear.tint(classColor ?? Color(.red)))
//        .glassEffect(.clear)
//        .lineLimit(1)
//    }
//}
//
//extension Color {
//    func lighter(by percentage: Double = 0.3) -> Color {
//        return self.adjust(by: abs(percentage))
//    }
//    
//    func darker(by percentage: Double = 0.3) -> Color {
//        return self.adjust(by: -abs(percentage))
//    }
//    
//    private func adjust(by percentage: Double) -> Color {
//        #if canImport(UIKit)
//        guard let components = UIColor(self).cgColor.components else { return self }
//        #elseif canImport(AppKit)
//        guard let components = NSColor(self).cgColor.components else { return self }
//        #endif
//        
//        return Color(
//            red: min(max(components[0] + percentage, 0), 1),
//            green: min(max(components[1] + percentage, 0), 1),
//            blue: min(max(components[2] + percentage, 0), 1),
//            opacity: components.count > 3 ? components[3] : 1
//        )
//    }
//}

struct AssignmentListView: View {
    
    let assignment: Assignment
    @State var classColor: Color?
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
            HStack {
                VStack(alignment: .leading) {
                    Text(assignment.name ?? "there is no name for this assignment")
                        .font(.headline)
                    if let formattedDate = assignment.formattedDate {
                        Text(formattedDate)
                            .foregroundColor(Color(#colorLiteral(red: 0.370555222, green: 0.3705646992, blue: 0.3705595732, alpha: 1)))
                            .font(.subheadline)
                    }
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.title2)
                    .bold()
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .glassEffect(.regular.interactive())
//        .overlay {
//            Capsule()
//                .stroke(classColor ?? Color(.clear), lineWidth: 2) // Match your shape
//        }
        .contentShape(Capsule())
        .lineLimit(1)
    }
}

#Preview {
    AssignmentListView(assignment: Assignment(
        name: "some assignment",
        desc: "lorem ipsum dolor",
        dueDate: Date())
    )
}
