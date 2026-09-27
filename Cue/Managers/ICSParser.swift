import iCalendarParser
import Foundation

nonisolated struct ParsedClass: Sendable {
    var id: UUID
    let originalName: String?
    var assignments: [ParsedAssignment]
    
    init(originalName: String, assignments: [ParsedAssignment] = []) {
           self.id = UUID()
           self.originalName = originalName
           self.assignments = assignments
       }
}

nonisolated struct ParsedAssignment: Sendable {
    let icsUID: String
    let name: String?
    let desc: String?
    let dueDate: Date?
}


actor ICSParser {
    
    func fetchCalendarData(_ icsURL: String) async -> String? {
        
        
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
            return nil
        }
    }
    
    
    // Convert raw ics string into temporary structs
    func parseCalendarData(icsString: String) async -> [ParsedClass] {
        let calParser = ICParser()
        var classes: [ParsedClass] = []
        guard let calendar = calParser.calendar(from: icsString) else {
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
}
