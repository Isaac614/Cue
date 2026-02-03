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
@Observable
class CalendarViewModel {
//    var classes: [Class] = []
//    var isLoading = false
//    var errorMessage: String?
    
    var classes: [ParsedClass] = []
    var isLoading = false
    var errorMessage: String?
    
    var icsURL: URL?
    
    init(icsURL: URL?) {
        self.icsURL = icsURL
    }
    
    func updateCalendar(context: ModelContext) async {
        guard let icsString = await fetchCalendarData(context: context) else { return }
//        await clearSwiftData(context)
        await parseRawData(icsString: icsString, context: context)
        await updateContext(context)
        await sortAllClassAssignments(context)
        
    }
    
    
    private func fetchCalendarData(context: ModelContext) async -> String? {
        isLoading = true
        errorMessage = nil
        
        guard let icsURL = self.icsURL else {
            return nil
        }
        do {
            let (data, _) = try await URLSession.shared.data(from: icsURL)
            if let icsString = String(data: data, encoding: .utf8) {
                print("Successfully fetched ICS data:")
                return(icsString)
            }
            return nil
            
        } catch {
            return nil
        }
    }
    
    private func parseRawData(icsString: String, context: ModelContext) async {
        let calParser = ICParser()
        guard let calendar = calParser.calendar(from: icsString) else {
            errorMessage = "Failed to parse calendar data"
            return
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
            
            
            if let index = classes.firstIndex(where: { $0.originalName == className }) {
                // Mutate the actual element in the array
                classes[index].assignments.append(
                    ParsedAssignment(
                        icsUID: icsUID,
                        name: conciseSummary,
                        desc: desc,
                        dueDate: dueDate
                    )
                )
            } else {
                // Element not found → create a new struct and append
                let newClass = ParsedClass(
                    originalName: className ?? "Unnamed Class",
                    assignments: [
                        ParsedAssignment(
                            icsUID: icsUID,
                            name: conciseSummary,
                            desc: desc,
                            dueDate: dueDate
                        )
                    ]
                )
                classes.append(newClass)
            }
        }
    }
    
    private func updateContext(_ context: ModelContext) async {
        for parsedClass in classes {
            var classObj: Class
            
            if let originalName = parsedClass.originalName {
                // Use a local constant in the predicate
                let nameToSearch = parsedClass.originalName
                let classFetch = FetchDescriptor<Class>(predicate: #Predicate { $0.originalName == originalName })
                classObj = (try? context.fetch(classFetch).first) ?? Class(id: parsedClass.id, originalName: originalName)
            } else {
                // No name → always create a new class
                classObj = Class(id: parsedClass.id, originalName: "Unnamed Class")
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
            
            context.insert(classObj)
        }

        try? context.save()
    }

    
    private func clearSwiftData(_ context: ModelContext) async {
        classes.removeAll()
        
        let classes = try? context.fetch(FetchDescriptor<Class>())
        classes?.forEach { context.delete($0) }
        
        try? context.save()
    }
    
    func sortAllClassAssignments(_ context: ModelContext) async {
        // Fetch all classes from the model context
        let descriptor = FetchDescriptor<Class>()
        guard let classes = try? context.fetch(descriptor) else { return }
        
        // Sort assignments for each class
        for classObj in classes {
            classObj.assignments.sort { a, b in
                // Sort by due date
                guard let dateA = a.dueDate, let dateB = b.dueDate else {
                    return false
                }
                if dateA != dateB {
                    return dateA < dateB
                }
                
                // Fallback: sort by name
                let nameA = a.name ?? ""
                let nameB = b.name ?? ""
                return nameA < nameB
            }
        }
        
        // Save the context
        try? context.save()
    }
}



//@MainActor
//@Observable
//class CalendarViewModel {
//    var classes: [Class] = []
//    var isLoading = false
//    var errorMessage: String?
//    
//    var icsURL: URL?
//    
//    init(icsURL: URL?) {
//        self.icsURL = icsURL
//    }
//    
//    func updateCalendar(context: ModelContext) async {
//        guard let icsString = await fetchCalendarData(context: context) else { return }
//        await clearSwiftData(context)
//        await parseRawData(icsString: icsString, context: context)
//        await updateContext(context)
//        await sortAllClassAssignments(context)
//        
//    }
//    
//    
//    private func fetchCalendarData(context: ModelContext) async -> String? {
//        isLoading = true
//        errorMessage = nil
//        
//        guard let icsURL = self.icsURL else {
//            return nil
//        }
//        do {
//            let (data, _) = try await URLSession.shared.data(from: icsURL)
//            if let icsString = String(data: data, encoding: .utf8) {
//                print("Successfully fetched ICS data:")
//                return(icsString)
//            }
//            return nil
//            
//        } catch {
//            return nil
//        }
//    }
//    
//    private func parseRawData(icsString: String, context: ModelContext) async {
//        let calParser = ICParser()
//        guard let calendar = calParser.calendar(from: icsString) else {
//            errorMessage = "Failed to parse calendar data"
//            return
//        }
//        
//        for event in calendar.events {
//            var className: String?
//            
//            let summary: String? = event.summary
//            var conciseSummary: String?
//            
//            let desc: String?  = event.description
//            
//            let dueDate = event.dtEnd?.date ?? event.dtStart?.date
//            
//            if let summary = summary,
//               let inside = summary.split(separator: "[")
//                .last?
//                .split(separator: "]")
//                .first {
//                className = String(inside)
//                
//                if let range = summary.range(of: "[\(inside)]") {
//                        conciseSummary = summary.replacingCharacters(in: range, with: "").trimmingCharacters(in: .whitespaces)
//                    } else {
//                        conciseSummary = summary
//                    }
//            }
//            
//            var foundClass: Class?
//            for classObject in classes {
//                if classObject.originalName == className {
//                    foundClass = classObject
//                }
//            }
//            
//            if let foundClass = foundClass {
//                foundClass.addAssignment(Assignment(name: conciseSummary, desc: desc, dueDate: dueDate, parentClass: foundClass))
//            } else {
//                let newClass = Class(originalName: className)
//                addClass(newClass)
//                newClass.addAssignment(Assignment(name: conciseSummary, desc: desc, dueDate: dueDate, parentClass: newClass))
//                
//            }
//        }
//    }
//    
//    private func addClass(_ classObject: Class) {
//        classes.append(classObject)
//    }
//    
//    private func updateContext(_ context: ModelContext) async {
//        // Now insert newly parsed objects
//        for classObj in classes {
//            context.insert(classObj)
//        }
//        
//        try? context.save()
//    }
//    
//    private func clearSwiftData(_ context: ModelContext) async {
//        classes.removeAll()
//        
//        let classes = try? context.fetch(FetchDescriptor<Class>())
//        classes?.forEach { context.delete($0) }
//        
//        try? context.save()
//    }
//    
//    func sortAllClassAssignments(_ context: ModelContext) async {
//        // Fetch all classes from the model context
//        let descriptor = FetchDescriptor<Class>()
//        guard let classes = try? context.fetch(descriptor) else { return }
//        
//        // Sort assignments for each class
//        for classObj in classes {
//            classObj.assignments.sort { a, b in
//                // Sort by due date
//                guard let dateA = a.dueDate, let dateB = b.dueDate else {
//                    return false
//                }
//                if dateA != dateB {
//                    return dateA < dateB
//                }
//                
//                // Fallback: sort by name
//                let nameA = a.name ?? ""
//                let nameB = b.name ?? ""
//                return nameA < nameB
//            }
//        }
//        
//        // Save the context
//        try? context.save()
//    }
//}
