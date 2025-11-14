//
//  ClassListView.swift
//  Cue
//
//  Created by Isaac Moore on 11/13/25.
//

import SwiftUI

//struct ClassListView: View {
//    let className: String
//    @State private var isPressed = false
//
//    var body: some View {
////        HStack {
////            Text(className)
////                .font(.headline)
////                .padding(.horizontal, 20)
////                .padding(.vertical, 10)
////                .frame(maxWidth: .infinity)
////                .background {
////                    Capsule()
////                        .fill(Color.clear)
////                        .glassEffect(.regular)
////                        .scaleEffect(isPressed ? 0.9 : 1.0)
////                }
////                .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isPressed)
////                .contentShape(Capsule())
////                .gesture(
////                    DragGesture(minimumDistance: 0)
////                        .onChanged { _ in isPressed = true }
////                        .onEnded { _ in isPressed = false }
////                )
////            
////            
////            Spacer()
////            Image(systemName: "chevron.right")
////        }
//        
//        
//        
//        HStack {
//            Text(className)
//            
//            
//            Spacer()
//            Image(systemName: "chevron.right")
//        }
//        .font(.title2)
//        .bold()
//        .padding(.horizontal, 30)
//        .padding(.vertical, 30)
//        .frame(maxWidth: .infinity)
//        .background {
//            Capsule()
//                .fill(Color.clear)
//                .glassEffect(.regular)
//                .scaleEffect(isPressed ? 0.9 : 1.0)
//        }
//        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isPressed)
//        .contentShape(Capsule())
//        .gesture(
//            DragGesture(minimumDistance: 0)
//                .onChanged { _ in isPressed = true }
//                .onEnded { _ in isPressed = false }
//        )
//    }
//}


struct ClassListView: View {
    let className: String
    var isPressed: Bool = false

    var body: some View {
        HStack {
            Text(className)
            Spacer()
            Image(systemName: "chevron.right")
        }
        .font(.title2)
        .bold()
        .padding(.horizontal, 30)
        .padding(.vertical, 30)
        .frame(maxWidth: .infinity)
        .background {
            Capsule()
                .fill(Color.clear)
                .glassEffect(.regular)
        }
        .contentShape(Capsule())
        .scaleEffect(isPressed ? 1.1 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isPressed)
    }
}


#Preview {
    ClassListView(className: "Math 108X")
}
