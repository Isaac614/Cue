//
//  InputView.swift
//  Cue
//
//  Created by Isaac Moore on 11/12/25.
//

import SwiftUI

struct InputView: View {
    @State private var icsLink: String = "https://byui.instructure.com/feeds/calendars/user_MW9zKHiVd9h9cuWWsZjt5i1zHLRYUrt3wzEo4xjC.ics"
    let viewModel: CalendarViewModel

    var body: some View {
        VStack(spacing: 12) {
            TextField("Enter your ICS link...", text: $icsLink)
                .padding(.horizontal, 20)
                .frame(height: 55)
                .frame(maxWidth: .infinity)
                .font(.body)
                .glassEffect(.regular.tint(Color(red: 0.8, green: 0.9, blue: 1)).interactive())
        

            
            Button(
                action: {
                    viewModel.icsURL = URL(string: icsLink)
                    Task {
                        await viewModel.fetchCalendarData()
                    }
                }, label: {
                    Text("Submit")
                        .font(.title2)
                        .padding(.horizontal)
                        .padding(.vertical, 20)
                        .frame(maxWidth: .infinity)
                        .foregroundStyle(.black)
                }
            )
            .buttonStyle(.glass(.regular))//.tint(Color(red: 0.5, green: 0.6, blue: 1))))
        }
        .padding()
    }
}

#Preview {
    InputView(viewModel: CalendarViewModel(icsURL: nil))
}