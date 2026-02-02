import SwiftUI

struct ClassListView: View {
    let classObject: Class
    
    var className:String {
        classObject.userName
    }
    
//    var isPressed: Bool = false
    
    
    var body: some View {
        HStack {
            Text(className)
            Spacer()
            Image(systemName: "chevron.right")
        }
        .font(.title2)
        .bold()
        .padding(.horizontal, 30)
        .padding(.vertical, 30)
        .frame(maxWidth: .infinity)
        .glassEffect(.regular.tint(Color("CapsuleGlassColor")))//.interactive())
        .contentShape(Capsule())
        .foregroundStyle(
            classObject.color
        )
    }
}
