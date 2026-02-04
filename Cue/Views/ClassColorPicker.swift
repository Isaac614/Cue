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
                    
                    
                    
                    VStack(spacing: 20) {
                        HStack {
                            Spacer()
                            Button {
                                classObject.color = Color("TextColor")
                            } label: {
                                Circle()
                                    .fill(Color("TextColor"))
                                    .frame(width: 40, height: 40)
                            }
                            
                            Spacer()
                            Button {
                                classObject.color = Color(red: 1, green: 69/255, blue: 116/255)
                            } label: {
                                Circle()
                                    .fill(Color(red: 1, green: 69/255, blue: 116/255))
                                    .frame(width: 40, height: 40)
                            }
                            
                            Spacer()
                            Button {
                                classObject.color = Color(red: 255/255, green: 167/255, blue: 138/255)
                            } label: {
                                Circle()
                                    .fill(Color(red: 255/255, green: 167/255, blue: 138/255))
                                    .frame(width: 40, height: 40)
                            }
                            
                            Spacer()
                            Button {
                                classObject.color = Color(red: 255/255, green: 193/255, blue: 94/255)
                            } label: {
                                Circle()
                                    .fill(Color(red: 255/255, green: 193/255, blue: 94/255))
                                    .frame(width: 40, height: 40)
                            }
                            
                            Spacer()
                            Button {
                                classObject.color = Color(red: 63/255, green: 178/255, blue: 80/255)
                            } label: {
                                Circle()
                                    .fill(Color(red: 63/255, green: 178/255, blue: 80/255))
                                    .frame(width: 40, height: 40)
                            }
                            
                            Spacer()
                        }
                        HStack {
                            Spacer()
                            Button {
                                classObject.color = Color(red: 77/255, green: 182/255, blue: 172/255)
                            } label: {
                                Circle()
                                    .fill(Color(red: 77/255, green: 182/255, blue: 172/255))
                                    .frame(width: 40, height: 40)
                            }
                            
                            Spacer()
                            Button {
                                classObject.color = Color(red: 100/255, green: 181/255, blue: 246/255)
                            } label: {
                                Circle()
                                    .fill(Color(red: 100/255, green: 181/255, blue: 246/255))
                                    .frame(width: 40, height: 40)
                            }
                            
                            Spacer()
                            Button {
                                classObject.color = Color(red: 179/255, green: 157/255, blue: 219/255)
                            } label: {
                                Circle()
                                    .fill(Color(red: 179/255, green: 157/255, blue: 219/255))
                                    .frame(width: 40, height: 40)
                            }
                            
                            Spacer()
                            Button {
                                classObject.color = Color(red: 240/255, green: 98/255, blue: 146/255)
                            } label: {
                                Circle()
                                    .fill(Color(red: 240/255, green: 98/255, blue: 146/255))
                                    .frame(width: 40, height: 40)
                            }
                            
                            Spacer()
                            ColorPicker("", selection: $classObject.color)
                                .frame(width: 40, height: 40)
                                .scaleEffect(1.7)
                            .labelsHidden()
                            .onChange(of: classObject.color) { oldValue, newValue in
                                if let rgba = classObject.color.getRGBA() {
                                    classObject.red = rgba.red
                                    classObject.green = rgba.green
                                    classObject.blue = rgba.blue
                                    classObject.opacity = rgba.alpha
                                }
                            }
                            
                            Spacer()
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
