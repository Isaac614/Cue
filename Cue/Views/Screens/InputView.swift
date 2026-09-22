import SwiftUI

struct InputView: View {
    //    @State private var icsLink: String = ""
    @AppStorage("calendarURL") private var icsLink = ""
    
    
    let manager: ICSManager
    
    @Environment(\.modelContext) var modelContext
    @Environment(\.colorScheme) var colorScheme
    
    var buttonGradientGood: LinearGradient {
        if colorScheme == .dark {
            return LinearGradient(
                colors: [
                    Color(red: 0.16, green: 0.57, blue: 0.37),
                    Color(red: 0.10, green: 0.38, blue: 0.29),
                    Color(red: 0.08, green: 0.32, blue: 0.25)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        } else {
            return LinearGradient(
                colors: [
                    Color(red: 0.6, green: 1, blue: 0.6),
                    Color(red: 0.5, green: 1.0, blue: 0.8)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            }
        }

    
    var body: some View {
        ZStack {
            ScrollView {
                VStack(spacing: 12) {
                    Text("Connect your Canvas calendar")
                        .font(.title)
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                        .padding(.top)
                    
                    
                    Text("Paste your calendar feed link to bring in your assignments and due dates.")
                        .padding(.bottom)
                        .padding(.top, -6)
                        .foregroundStyle(Color("SubheadlineColor"))
                    
                    
                    Text("Calendar feed link")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading)
                        .foregroundStyle(Color("SubheadlineColor"))
                    TextField("https://school.instructure.com", text: $icsLink)
                        .padding(.horizontal, 20)
                        .frame(height: 55)
                        .font(.body)
                        .glassEffect(.regular.interactive())
                    
                    
                    Divider()
                        .padding(.vertical, 20)
                        .padding(.horizontal)
                    
                    
                    Text("How to find your link")
                        .font(.title2)
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                    
                    HStack(alignment: .top) {
                        VStack{
                            Image(systemName: "info.circle")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 20)
                            
                        }
                        .padding(.trailing, 8)
                        Text("Use your phone's web browser, like Safari or Chrome. The Canvas Student app doesn't provide this link.")
                    }
                    .padding()
                    .background(Color("WarningColor"))
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                    .padding(.bottom)
                    
                    
                    VStack(alignment: .leading, spacing: 0) {
                        StepRow(number: 1, title: "Log in to Canvas", desc: "Open your school's Canvas website in your browser and sign in", isLast: false)
                        StepRow(number: 2, title: "Open Calendar", desc: "Tap the menu, then tap Calendar", isLast: false)
                        StepRow(number: 3, title: "Tap Calendar Feed", desc: "Scroll to the bottom of the page and look for \"Calendar Feed\"", isLast: false)
                        StepRow(number: 4, title: "Copy the link", desc: "Copy the calendar feed link, paste it above, and connect your calendar", isLast: true)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                    
                    Spacer()
                }
                .padding(.bottom, 120)
                .padding(.horizontal)
                .frame(maxHeight: .infinity)
            }
            .background(Color("BackgroundColor"))
            
            
            
            VStack {
                Spacer()
                LinearGradient(
                    colors: [
                        Color("BackgroundColor").opacity(0.01),
                        Color("BackgroundColor").opacity(1),
                        Color("BackgroundColor")
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(height: 200)
                .allowsHitTesting(false) // Allow taps to pass through
            }
            .ignoresSafeArea(edges: .bottom) // This makes it hug the bottom edge

            VStack {
                Spacer()
                
                Button (
                    action: {
                        Task {
                            await manager.updateCalendar(context: modelContext, icsURL: icsLink)
                        }
                    }, label: {
                        Text("Connect Calendar")
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .frame(height: 80)
                            .frame(maxWidth: .infinity)
                            .background(
                                Capsule()
                                    .fill(buttonGradientGood))
                            .font(.title3)
                            .bold()
                            .foregroundStyle(Color("TextColor"))
                    })
                                .padding(.horizontal, 23)
                                .padding(.bottom, 15)
                
            }
            
            
            
        }
        .background(Color("BackgroundColor"))
    }
}

#Preview {
    InputView(manager: ICSManager())
}
