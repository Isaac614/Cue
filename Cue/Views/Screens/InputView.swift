import SwiftUI

struct InputView: View {
    @State private var icsLink: String = ""
    
    
    let viewModel: ICSManager

    @Environment(\.modelContext) var modelContext
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                
                
                TextField("Enter your ICS link...", text: $icsLink)
                    .padding(.horizontal, 20)
                    .frame(height: 55)
                    .frame(maxWidth: .infinity)
                    .font(.body)
                    .glassEffect(.regular.interactive())
                
                Button(
                    action: {
                        
                    }, label: {
                        
                    }
                    
                )
            }

            
            Button(
                action: {
                    
                    Task {
                        await viewModel.updateCalendar(context: modelContext)
                    }
                }, label: {
                    Text("Submit")
                        .font(.title2)
                        .padding(.horizontal)
                        .padding(.vertical, 20)
                        .frame(maxWidth: .infinity)
                        .foregroundStyle(Color("TextColor"))
                }
            )
            .buttonStyle(.glass(.regular))//.tint(Color(red: 0.5, green: 0.6, blue: 1))))
        }
        .padding()
        .frame(maxHeight: .infinity)
        .background(Color("BackgroundColor"))
    }
}

#Preview {
    InputView(viewModel: ICSManager())
}
