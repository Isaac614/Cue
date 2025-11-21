import SwiftUI

struct AssignmentListView: View {
    
    let assignment: Assignment
    
    var completeColor: Color {
        assignment.isComplete ? Color(.green) : Color(.red)
    }
    
    var classColor: Color? {
        guard let r = assignment.red,
              let g = assignment.green,
              let b = assignment.blue else {
            return nil
        }
        
        return Color(red: r, green: g, blue: b)
    }
    
    var includeClass: Bool = false
    
    
    var body: some View {
        HStack(spacing: 0) {
            Button(
                action: {
                    assignment.markStatus()
                }, label: {
                    Image(systemName: assignment.isComplete ? "circle.fill" : "circle")
                        .resizable()
                        .foregroundStyle(classColor ?? completeColor)
                        .frame(width: 20, height: 20)
                })
            .buttonStyle(PlainButtonStyle())
            Spacer()
                .frame(width: 15)
            HStack {
                VStack(alignment: .leading) {
                    if !includeClass {
                        Text(assignment.name ?? "there is no name for this assignment")
                            .font(.headline)
                    } else {
                        Text("\(assignment.name ?? "there is no name for this assignment") - \(assignment.className ?? "Unnamed Class")")
                            .font(.headline)
                        
                    }
                    if let formattedDate = assignment.formattedDate {
                        Text(formattedDate)
                            .foregroundColor(Color("SubheadlineColor"))
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
        .glassEffect(.regular.tint(Color("CapsuleGlassColor")))
//        .overlay {
//            Capsule()
//                .stroke(classColor ?? Color(.clear), lineWidth: 2) // Match your shape
//        }
        .contentShape(Capsule())
        .lineLimit(1)
        .foregroundStyle(Color("TextColor"))
    }
}

//
//#Preview {
//    AssignmentListView(assignment: Assignment(
//        name: "some assignment",
//        desc: "lorem ipsum dolor",
//        dueDate: Date())
//    )
//}
