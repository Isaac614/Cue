import SwiftUI

struct ClassListView: View {
    let classObject: Class
    let onEdit: () -> Void
    let onDelete(): -> Void
    
    var uncompletedDueToday: [Assignment] {
        classObject.todaysAssignments.filter {
            !($0.isComplete)
        }
    }
    
    var numberAssignments: Int {
        uncompletedDueToday.count
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15)
                .fill(classObject.usesTextColor ? .accent : classObject.color)
                .offset(y: -3)
            VStack(alignment: .center) {
                Text(classObject.userName)
                    .font(.title2)
                    .bold()
                    .foregroundStyle(
                        classObject.color
                    )
                Text(numberAssignments != 0 ?
                     "\(numberAssignments) due today" :
                     "nothing due"
                )
                .font(.caption)
                .foregroundStyle(Color("SubheadlineColor"))
            }
            .padding(.horizontal, 30)
            .padding(.vertical, 20)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color("CapsuleColor"))
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .contextMenu {
                Button {
                    onEdit()
                } label: {
                    HStack {
                        Image(systemName: "paintpalette")
                        Text("Edit")
                    }
                }
                
                Button {
                    onDelete()
                } label: {
                    HStack {
                        Image(systemName: "trash")
                        Text("Delete")
                    }
                }
            }
        }
        
    }
    
}
