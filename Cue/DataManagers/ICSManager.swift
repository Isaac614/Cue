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


@MainActor
class ICSManager {
    
    var isLoading = false
    var errorMessage: String?
    
    func updateCalendar(context: ModelContext) async {
        isLoading = true
        guard let icsString = await fetchCalendarData("https://byui.instructure.com/feeds/calendars/user_MW9zKHiVd9h9cuWWsZjt5i1zHLRYUrt3wzEo4xjC.ics") else { return }
        let tempClasses = await parseCalendarData(icsString: icsString)
        await updateContext(context: context, tempClasses: tempClasses)
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
    
    
    private func updateContext(context: ModelContext, tempClasses: [ParsedClass]) async {
        
        for parsedClass in tempClasses {
            var classObj: Class
            
            if let originalName = parsedClass.originalName {
                let classFetch = FetchDescriptor<Class>(predicate: #Predicate { $0.originalName == originalName })
                classObj = (try? context.fetch(classFetch).first) ?? Class(id: parsedClass.id, originalName: originalName)
            } else {
                // No name → always create a new class
                classObj = Class(id: parsedClass.id, originalName: parsedClass.originalName)
                context.insert(classObj)
            }
            
            // Clear assignments that no longer exist in ICS
            classObj.assignments.removeAll { assignment in
                !parsedClass.assignments.contains(where: { $0.icsUID == assignment.icsUID })
            }
            
            // Add/update assignments
            for parsedAssignment in parsedClass.assignments {
                if !classObj.assignments.contains(where: { $0.icsUID == parsedAssignment.icsUID }) {
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
        
        try? context.save()
    }
    
    
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

