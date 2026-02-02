import SwiftUI
import SwiftData


struct ClassColorPicker: View {
    
    @Bindable var classObject: Class
    @Environment(\.dismiss) var dismiss
    
    let headerFadeOverlay = LinearGradient(
        colors: [
            Color("BackgroundColor").opacity(0.01),
            Color("BackgroundColor").opacity(0.4),
            Color("BackgroundColor")
        ],
        startPoint: .bottom,
        endPoint: .top
    )
    
    
    var body: some View {
        VStack {
            ZStack(alignment: .top) {
                VStack(spacing: 20) {
                    VStack {
                        Text("Display Name")
                            .multilineTextAlignment(.leading)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 10)
                        
                        TextField("Class Name", text: $classObject.userName)
                        
                            .padding(.horizontal, 20)
                            .frame(height: 55)
                            .frame(maxWidth: .infinity)
                            .font(.body)
                            .foregroundStyle(classObject.color)
                            .glassEffect(.regular.interactive())
                        
                    }
                    .padding(.horizontal, 20)
                    
                    
                    
                    
                    ColorPicker(selection: $classObject.color) {
                        HStack {
                            Image(systemName: "paintpalette")
                                .foregroundStyle(classObject.color)
                            Text("Color")
                                .font(.headline)
                        }
                    }
                    .padding(.horizontal, 20)
                    .onChange(of: classObject.color) { oldValue, newValue in
                        if let rgba = classObject.color.getRGBA() {
                            classObject.red = rgba.red
                            classObject.green = rgba.green
                            classObject.blue = rgba.blue
                            classObject.opacity = rgba.alpha
                        }
                    }
                }
                .padding(.top, 90)
                
                
                
                
                
                
                ZStack {
                    Spacer()
                    Text("Class Info")
                        .font(.headline)
                        .foregroundStyle(Color("TextColor"))
                        .frame(height: 44)
                    Spacer()
                }
                HStack {
                    Spacer()
                    
                    // Done button
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "checkmark")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundStyle(Color("TextColor"))
                            .frame(width: 44, height: 44)
//                            .background(Color.blue)
                            .clipShape(Circle())
                            .glassEffect(.regular.interactive())
                    }
                }
                .padding(.horizontal, 20)
            }
            Spacer()
        }
        .padding(.vertical, 20)
        .background(Color("BackgroundColor"))
    }
    
}


#Preview {
    // Create a FetchDescriptor to get Class objects
    let fetchDescriptor = FetchDescriptor<Class>() // fetch all
    let sampleClass = try! previewContainer.mainContext.fetch(fetchDescriptor).first!
    
    ClassColorPicker(classObject: sampleClass)
        .modelContainer(previewContainer)
}
