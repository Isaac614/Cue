import Foundation
import iCalendarParser
import SwiftUI
import SwiftData


@MainActor
@Observable
class CalendarViewModel {
    var classes: [Class] = []
    var isLoading = false
    var errorMessage: String?
    
    var icsURL: URL?
    
    init(icsURL: URL?) {
        self.icsURL = icsURL
    }
    
    func updateCalendar(context: ModelContext) async {
        guard let icsString = await fetchCalendarData(context: context) else { return }
        await clearSwiftData(context)
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
            
            var foundClass: Class?
            for classObject in classes {
                if classObject.originalName == className {
                    foundClass = classObject
                }
            }
            
            if let foundClass = foundClass {
                foundClass.addAssignment(Assignment(name: conciseSummary, desc: desc, dueDate: dueDate, parentClass: foundClass))
            } else {
                let newClass = Class(originalName: className)
                addClass(newClass)
                newClass.addAssignment(Assignment(name: conciseSummary, desc: desc, dueDate: dueDate, parentClass: newClass))
                
            }
        }
    }
    
    private func addClass(_ classObject: Class) {
        classes.append(classObject)
    }
    
    private func updateContext(_ context: ModelContext) async {
        // Now insert newly parsed objects
        for classObj in classes {
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



