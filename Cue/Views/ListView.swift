//
//  ListView.swift
//  Cue
//
//  Created by Isaac Moore on 11/10/25.
//

import SwiftUI

struct ListView: View {
    let viewModel = CalendarViewModel(icsURL: nil)
    @State private var selectedClass: Class? = nil
    @State private var pendingClass: Class? = nil
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 16) {
                    ForEach(viewModel.classes) { classObject in
                        Button {
                            pendingClass = classObject
                            // Delay navigation to let animation play
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                selectedClass = pendingClass
                                pendingClass = nil
                            }
                        } label: {
                            ClassListView(
                                className: classObject.name ?? "Unnamed Class",
                                isPressed: pendingClass?.id == classObject.id
                            )
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding()
            }
            .background(.white)
            .navigationTitle("Classes")
            .navigationDestination(item: $selectedClass) { classObject in
                ClassView(classObject: classObject)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink("Update") {
                        InputView(viewModel: viewModel)
                    }
                }
            }
        }
    }
}

#Preview {
    ListView()
}
