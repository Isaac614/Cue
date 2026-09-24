import Foundation
import iCalendarParser
import SwiftUI
import SwiftData


struct ParsedClass {
    var id: UUID
    let originalName: String?
    var assignments: [ParsedAssignment]
    
    init(originalName: String, assignments: [ParsedAssignment] = []) {
           self.id = UUID()
           self.originalName = originalName
           self.assignments = assignments
       }
}

struct ParsedAssignment {
    let icsUID: String
    let name: String?
    let desc: String?
    let dueDate: Date?
}

@Observable
@MainActor
class ICSManager {
    
    var isLoading = false
    var errorMessage: String?
    
    func updateCalendar(context: ModelContext, icsURL: String) async {
        print("updateCalendar called")
        isLoading = true
        print("calling fetch data")
        guard let icsString = await fetchCalendarData(icsURL) else { return }
        print("calling parse")
        let tempClasses = await parseCalendarData(icsString: icsString)
        print("calling update")
        print(tempClasses.count)
        await updateContext(context: context, tempClasses: tempClasses)
        print("updated")
        isLoading = false
    }
    
    // Gets raw ics string from the link
    private func fetchCalendarData(_ icsURL: String) async -> String? {
        errorMessage = nil
        
        guard let icsURL = URL(string: icsURL) else {
            return nil
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: icsURL)
            if let icsString = String(data: data, encoding: .utf8) {
                return(icsString)
            }
            return nil
            
        } catch {
            errorMessage = "there was an error"
            return nil
        }
    }
    
    
    // Convert raw ics string into temporary structs
    private func parseCalendarData(icsString: String) async -> [ParsedClass] {
        let calParser = ICParser()
        var classes: [ParsedClass] = []
        guard let calendar = calParser.calendar(from: icsString) else {
            errorMessage = "Failed to parse calendar data"
            return classes
        }
        
        for event in calendar.events {
            let icsUID = event.uid
            var className: String?
            
            let summary: String? = event.summary
            var conciseSummary: String?
            
            let desc: String?  = event.description
            
            let dueDate = event.dtEnd?.date ?? event.dtStart?.date
            
            if let summary = summary,
               let inside = summary.split(separator: "[")
                .last?
                .split(separator: "]")
                .first {
                className = String(inside)
                
                if let range = summary.range(of: "[\(inside)]") {
                        conciseSummary = summary.replacingCharacters(in: range, with: "").trimmingCharacters(in: .whitespaces)
                    } else {
                        conciseSummary = summary
                    }
            }
            
            let tempAssignment = ParsedAssignment(
                icsUID: icsUID,
                name: conciseSummary,
                desc: desc,
                dueDate: dueDate
            )
            
            if let index = classes.firstIndex(where: { $0.originalName == className }) {
                classes[index].assignments.append(tempAssignment)
            } else {
                // Element not found → create a new struct and append
                let newClass = ParsedClass(
                    originalName: className ?? "Unnamed Class",
                    assignments: [tempAssignment]
                )
                classes.append(newClass)
            }
        }
        return classes
    }
    
    
    // Converts temporary structs to objects that can be saved to swift data. Ensures that duplicates are handled and old classes are deleted.
    private func updateContext(context: ModelContext, tempClasses: [ParsedClass]) async {
        
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

    
    private func clearSwiftData(_ context: ModelContext) async {
        let classes = try? context.fetch(FetchDescriptor<Class>())
        classes?.forEach { context.delete($0) }
        
        try? context.save()
    }
}

