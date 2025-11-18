//
//  ListView.swift
//  Cue
//
//  Created by Isaac Moore on 11/10/25.
//

import SwiftUI

struct ListView: View {
    let viewModel = CalendarViewModel(icsURL: nil)
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 16) {
                    ForEach(viewModel.classes) { classObject in
                        NavigationLink {
                            ClassView(classObject: classObject)
                        } label: {
                            ClassListView(classObject: classObject)
                        }
                    }
                }
                .padding()
            }
            .background(.white)
            .navigationTitle("Classes")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink("Update") {
                        InputView(viewModel: viewModel)
                    }
                }
//                ToolbarItem(placement: .topBarLeading) {
//                   Button (
//                    action: {
//                        viewModel.icsURL = URL(string: "https://byui.instructure.com/feeds/calendars/user_MW9zKHiVd9h9cuWWsZjt5i1zHLRYUrt3wzEo4xjC.ics")
//                        Task {
//                            await viewModel.fetchCalendarData()
//                        }
//                    }, label: {
//                        Image(systemName: "arrow.clockwise")
//                    })
//                }
//                ToolbarItem(placement: .topBarLeading) {
//                    Button (
//                        action: {
//                            for classObj: Class in viewModel.classes {
//                                classObj.red = 1
//                                classObj.green = 0.75
//                                classObj.blue = 0.8
//                                classObj.opacity = 0.5
//                            }
//                        }, label: {
//                            Image(systemName: "keyboard")
//                        })
//                }
            }
        }
    }
}

#Preview {
    ListView()
}




////
////  ListView.swift
////  Cue
////
////  Created by Isaac Moore on 11/10/25.
////
//
//import SwiftUI
//
//struct ListView: View {
//    let viewModel = CalendarViewModel(icsURL: nil)
//    @State private var showColorPicker = false
//    @State private var selectedColor = Color.blue
//    
//    var body: some View {
//        NavigationStack {
//            ScrollView {
//                LazyVStack(spacing: 16) {
//                    ForEach(viewModel.classes) { classObject in
//                        NavigationLink {
//                            ClassView(classObject: classObject)
//                        } label: {
//                            ClassListView(classObject: classObject)
//                        }
//                    }
//                }
//                .padding()
//            }
//            .background(.white)
//            .navigationTitle("Classes")
//            .toolbar {
//                ToolbarItem(placement: .topBarTrailing) {
//                    NavigationLink("Update") {
//                        InputView(viewModel: viewModel)
//                    }
//                }
//                
//                ToolbarItem(placement: .topBarLeading) {
//                    Button {
//                        showColorPicker.toggle()
//                    } label: {
//                        Image(systemName: "paintpalette")
//                    }
//                }
//            }
//            .sheet(isPresented: $showColorPicker) {
//                VStack(spacing: 20) {
//                    Text("Pick a Color")
//                        .font(.headline)
//                    
//                    ColorPicker("Select Color", selection: $selectedColor, supportsOpacity: true)
//                        .padding()
//                    
//                    // Preview circle
//                    Circle()
//                        .fill(selectedColor)
//                        .frame(width: 100, height: 100)
//                    
//                    Button("Done") {
//                        showColorPicker = false
//                    }
//                    .buttonStyle(.borderedProminent)
//                }
//                .padding()
//                .presentationDetents([.medium])
//            }
//        }
//    }
//}
//
//#Preview {
//    ListView()
//}
