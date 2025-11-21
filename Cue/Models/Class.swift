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
    var originalName: String?
    var userName: String?
    
    @Relationship(deleteRule: .cascade) var assignments: [Assignment]
    var red: Double? = nil
    var blue: Double? = nil
    var green: Double? = nil
    var opacity: Double? = nil
    
    
    
    init(originalName: String?, assignments: [Assignment] = [], color: Color? = nil, userName: String? = nil) {
        self.originalName = originalName
        self.assignments = assignments
        self.userName = userName ?? originalName
        
        
        if let color = color {
            #if canImport(UIKit)
            if let components = UIColor(color).cgColor.components {
                self.red = Double(components[0])
                self.green = Double(components[1])
                self.blue = Double(components[2])
                self.opacity = components.count > 3 ? Double(components[3]) : 1.0
            }
            #elseif canImport(AppKit)
            if let components = NSColor(color).cgColor.components {
                self.red = Double(components[0])
                self.green = Double(components[1])
                self.blue = Double(components[2])
                self.opacity = components.count > 3 ? Double(components[3]) : 1.0
            }
            #endif
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
