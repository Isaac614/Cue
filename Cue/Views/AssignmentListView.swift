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
    
    
    var body: some View {
        HStack {
            Button(
                action: {
                    assignment.markStatus()
                }, label: {
                    Image(systemName: assignment.isComplete ? "circle.fill" : "circle")
                        .foregroundStyle(classColor ?? completeColor)
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
        .glassEffect(.regular)
//        .overlay {
//            Capsule()
//                .stroke(classColor ?? Color(.clear), lineWidth: 2) // Match your shape
//        }
        .contentShape(Capsule())
        .lineLimit(1)
        .foregroundStyle(Color(.black))
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
