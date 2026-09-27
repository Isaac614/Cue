import Foundation
import iCalendarParser
import SwiftUI
import SwiftData


@Observable
@MainActor
class ICSManager {
    
    var isLoading = false
    var errorMessage: String?
    let parser: ICSParser = ICSParser()
    
    func updateCalendar(context: ModelContext, icsURL: String) async {
        isLoading = true
        guard let icsString = await parser.fetchCalendarData(icsURL) else { return }
        let tempClasses = await parser.parseCalendarData(icsString: icsString)
        updateContext(context: context, tempClasses: tempClasses)
        isLoading = false
    }
   
    
    // Converts temporary structs to objects that can be saved to swift data. Ensures that duplicates are handled and old classes are deleted.
    private func updateContext(context: ModelContext, tempClasses: [ParsedClass]) {
        
        for parsedClass in tempClasses {
            var classObj: Class
            
            if let originalName = parsedClass.originalName {
                let classFetch = FetchDescriptor<Class>(predicate: #Predicate { $0.originalName == originalName })
                if let existing = try? context.fetch(classFetch).first {
                    classObj = existing
                } else {
                    classObj = Class(id: parsedClass.id, originalName: originalName)
                    context.insert(classObj)
                }
            } else {
                // No name → always create a new class
                classObj = Class(id: parsedClass.id, originalName: parsedClass.originalName)
                context.insert(classObj)
            }
            
            // Clear assignments that no longer exist in ICS
            classObj.assignments.removeAll { assignment in
                let shouldRemove = !parsedClass.assignments.contains(where: { $0.icsUID == assignment.icsUID })
                if shouldRemove {
                    context.delete(assignment)
                }
                return shouldRemove
            }
            
            // Add/update assignments
            for parsedAssignment in parsedClass.assignments {
                if let existingAssignment = classObj.assignments.first(where: { $0.icsUID == parsedAssignment.icsUID }) {
                    existingAssignment.name = parsedAssignment.name
                    existingAssignment.desc = parsedAssignment.desc
                    existingAssignment.dueDate = parsedAssignment.dueDate
                    existingAssignment.updateSubmissionStatus()
                } else {
                    let assignment = Assignment(
                        icsUID: parsedAssignment.icsUID,
                        name: parsedAssignment.name,
                        desc: parsedAssignment.desc,
                        dueDate: parsedAssignment.dueDate,
                        parentClass: classObj
                    )
                    classObj.addAssignment(assignment)
                }
            }
            
            
        }
        removeOldClasses(context: context);
        
        do {
            try context.save()
        } catch {
            print("Failed to save SwiftData context: \(error)")
        }
    }
    
    // removes classes with no assignments in them; ie old classes
    private func removeOldClasses(context: ModelContext) {
        let classFetch = FetchDescriptor<Class>()

        if let existingClasses = try? context.fetch(classFetch) {
            for classObj in existingClasses {
                if classObj.assignments.isEmpty {
                    context.delete(classObj)
                }
            }
        }
    }

    
    private func clearSwiftData(_ context: ModelContext) {
        let classes = try? context.fetch(FetchDescriptor<Class>())
        classes?.forEach { context.delete($0) }
        
        try? context.save()
    }
}
