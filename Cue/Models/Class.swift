import Foundation
import SwiftData
import SwiftUI

#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

@Model
final class Class: Hashable {
    var originalName: String
//    var userName: String?
    var userName: String
    
    @Relationship(deleteRule: .cascade) var assignments: [Assignment]
    
    var red: Double? = nil
    var blue: Double? = nil
    var green: Double? = nil
    var opacity: Double? = nil
    
    var color: Color {
        get {
            if let red = red, let green = green, let blue = blue, let opacity = opacity {
                return Color(red: red, green: green, blue: blue, opacity: opacity)
            } else {
                return Color("TextColor")
            }
        }
        set {
            if let rgba = newValue.getRGBA() {
                red = rgba.red
                green = rgba.green
                blue = rgba.blue
                opacity = rgba.alpha
            }
        }
    }
    
    
    init(originalName: String?, assignments: [Assignment] = [], color: Color? = nil, userName: String? = nil) {
        self.originalName = originalName ?? "Unnamed Class"
        if let userName {
            self.userName = userName
        } else {
            self.userName = originalName ?? "Unnamed Class"
        }
        self.assignments = assignments
        
        
        if let color = color, let rgba = color.getRGBA() {
            self.red = rgba.red
            self.green = rgba.green
            self.blue = rgba.blue
            self.opacity = rgba.alpha
        } else {
            self.red = nil
            self.green = nil
            self.blue = nil
            self.opacity = nil
        }
    }

    func addAssignment(_ assignment: Assignment) {
        assignments.append(assignment)
    }
    

    static func == (lhs: Class, rhs: Class) -> Bool {
        lhs === rhs  // compare references
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self))
    }
    
    
}
