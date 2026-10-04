import SwiftUI

struct AssignmentListView: View {
    
    let assignment: Assignment
    var includeClass: Bool = false
    
    var tintColor: Color {
        assignment.parentClass.color
    }
    
    
    var body: some View {
        
        HStack(spacing: 0) {
            Button(
                action: {
                    assignment.markStatus()
                }, label: {
                    Image(systemName: assignment.isComplete ? "circle.fill" : "circle")
                        .resizable()
                        .foregroundStyle(assignment.parentClass.color)
                        .frame(width: 20, height: 20)
                })
            .buttonStyle(PlainButtonStyle())
            Spacer()
                .frame(width: 15)
            HStack {
                VStack(alignment: .leading) {
                    
                    Text(assignment.className)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                        .background(Color(tintColor).opacity(0.16), in: Capsule())
                        .foregroundStyle(tintColor)
                        .font(.caption)
                        .fontWeight(.semibold)
                    
                    Text(assignment.name ?? "name not found")
                        .lineLimit(1)
                        .foregroundStyle(Color("TextColor"))
                }
                .font(.subheadline)
                .foregroundStyle(Color("TextColor"))
                Spacer()
                HStack {
                    if let formattedDate = assignment.formattedDate {
                        Text(formattedDate)
                            .font(.subheadline)
                            .foregroundColor(Color("SubheadlineColor"))
                    }
                    Image(systemName: "chevron.right")
                        .font(.subheadline)
                        .bold()
                }
            }
        }
        .padding(15)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color("CapsuleColor"), in:Capsule())
        .contentShape(Capsule())
        .foregroundStyle(Color("TextColor"))
        .overlay(
            Capsule()
                .stroke(Color("CapsuleBorderColor"), lineWidth: 1)
        )
        .padding(.horizontal, 1)
        
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
