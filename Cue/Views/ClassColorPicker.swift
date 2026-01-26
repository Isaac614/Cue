import SwiftUI

struct ClassColorPicker: View {
    private var classObject: Class
    @State private var selectedColor: Color
    
    init(classObject: Class) {
            self.classObject = classObject
            _selectedColor = State(initialValue: classObject.color)
        }
    
    var body: some View {
        VStack {
            ColorPicker("Background Color", selection: $selectedColor)
                .padding()
        
            
            Rectangle()
                .fill(selectedColor)
                .frame(width: 100, height: 100)
                .cornerRadius(8)
                .padding()
        }
    }
}


//#Preview {
//    ClassColorPicker()
//}
