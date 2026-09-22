import SwiftUI

struct StepRow : View {
    
    let number: Int
    let title: String
    let desc: String
    let isLast: Bool
    
    var body: some View {
        HStack(alignment: .top) {
            VStack(spacing: 0) {
                Text(String(number))
                    .frame(width: 40, height: 40)
                    .background(Color("AccentColor"), in: Circle())
                    .font(.title3)
                    .bold()
                    .foregroundStyle(Color("AccentTextColor"))
                    
                if !isLast {
                    Rectangle()
                        .padding(.vertical, 0)
                        .frame(width: 2)
                }
            }
            .padding(.trailing, 8)
            
            VStack(alignment: .leading) {
                Text(title)
                    .font(.title3)
                    .bold()
                
                Text(desc)
                    .font(.body)
                    .foregroundStyle(Color("SubheadlineColor"))
            }
            .padding(.bottom, 35)
        }
        .padding(.vertical, 0)
//        .fixedSize(horizontal: false, vertical: true)
    }
}

#Preview {
    StepRow(number: 1, title: "Log in to Canvas", desc: "Open your school's Canvas website in your browser and sign in.", isLast: false)
}
