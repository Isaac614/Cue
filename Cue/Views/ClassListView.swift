//
//  ClassListView.swift
//  Cue
//
//  Created by Isaac Moore on 11/13/25.
//

import SwiftUI

struct ClassListView: View {
    let classObject: Class
//    let className: String
    var isPressed: Bool = false

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
        .foregroundStyle(Color(
                red: classObject.red,
                green: classObject.green,
                blue: classObject.blue
            )
        )
    }
}


//#Preview {
//    ClassListView(className: "Math 108X")
//}
