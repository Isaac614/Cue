import SwiftUI

struct ClassListView: View {
    let classObject: Class
    
    
    var body: some View {
        HStack {
            Text(classObject.userName)
            Spacer()
            Image(systemName: "chevron.right")
        }
        .font(.title2)
        .bold()
        .padding(.horizontal, 30)
        .padding(.vertical, 30)
        .frame(maxWidth: .infinity)
        .glassEffect(.regular.tint(Color("CapsuleGlassColor")))
        .contentShape(Capsule())
        .foregroundStyle(
            classObject.color
        )
    }
}
