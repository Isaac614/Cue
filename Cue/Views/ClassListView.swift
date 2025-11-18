//
//  ClassListView.swift
//  Cue
//
//  Created by Isaac Moore on 11/13/25.
//

import SwiftUI

struct ClassListView: View {
    let classObject: Class
    var isPressed: Bool = false
    var classColor: Color {
        guard let r = classObject.red,
              let g = classObject.green,
              let b = classObject.blue else {
            return Color(.black)
        }
        
        return Color(red: r, green: g, blue: b)
    }

    var body: some View {
        HStack {
            Text(classObject.name ?? "Unnamed Class")
            Spacer()
            Image(systemName: "chevron.right")
        }
        .font(.title2)
        .bold()
        .padding(.horizontal, 30)
        .padding(.vertical, 30)
        .frame(maxWidth: .infinity)
        .glassEffect(.regular.interactive())
        .contentShape(Capsule())
        .foregroundStyle(
            classColor
        )
    }
}
