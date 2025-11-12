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
            List {
                ForEach(viewModel.classes) { classObject in
                    NavigationLink {
                        ClassView(classObject: classObject)
                    } label: {
                        Text(classObject.name ?? "Unnamed Class")
                    }
                }
            }
            .navigationTitle("Classes")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink {
                        InputView(viewModel: viewModel)
                    } label: {
                        Text("Update")
                    }
                }
            }
        }
    }
}

#Preview {
    ListView()
}
