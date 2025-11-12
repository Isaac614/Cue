//
//  Class.swift
//  Cue
//
//  Created by Isaac Moore on 11/11/25.
//

import Foundation
import SwiftData

@Model
final class Class {
    var name: String?
    var assignments: [Assignment]
    
    
    init(name: String?, assignments: [Assignment] = []) {
        self.name = name
        self.assignments = assignments
    }
    
    func addAssignment(_ assignment: Assignment) {
        assignments.append(assignment)
    }
}
