//
//  Class.swift
//  Cue
//
//  Created by Isaac Moore on 11/11/25.
//

import Foundation
import SwiftData

//@Model
//final class Class {
//    var name: String?
//    var assignments: [Assignment]
//    
//    
//    init(name: String?, assignments: [Assignment] = []) {
//        self.name = name
//        self.assignments = assignments
//    }
//    
//    func addAssignment(_ assignment: Assignment) {
//        assignments.append(assignment)
//    }
//}

import Foundation
import SwiftData

@Model
final class Class: Hashable {
    var name: String?
    var assignments: [Assignment]

    init(name: String?, assignments: [Assignment] = []) {
        self.name = name
        self.assignments = assignments
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

