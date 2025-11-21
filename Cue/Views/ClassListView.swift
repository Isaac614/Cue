import SwiftUI

struct ClassListView: View {
    let classObject: Class
    
    var className:String {
        classObject.userName ?? classObject.originalName ?? "Unnamed Class"
    }
    
    var isPressed: Bool = false
    
    var classColor: Color {
        guard let r = classObject.red,
              let g = classObject.green,
              let b = classObject.blue else {
            return Color("TextColor")
        }
        
        return Color(red: r, green: g, blue: b)
    }

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
        .glassEffect(.regular.tint(Color("CapsuleGlassColor")).interactive())
        .contentShape(Capsule())
        .foregroundStyle(
            classColor
        )
    }
}
