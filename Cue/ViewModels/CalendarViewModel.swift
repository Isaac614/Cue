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
    
    
    func fetchCalendarData(context: ModelContext) async {
        isLoading = true
        errorMessage = nil
        
        guard let icsURL = self.icsURL else {
            return
        }
        do {
            let (data, _) = try await URLSession.shared.data(from: icsURL)
            if let icsString = String(data: data, encoding: .utf8) {
                print("Successfully fetched ICS data:")
                parseRawData(icsString: icsString, context: context)
            }
            
        } catch {
            errorMessage = "Failed to fetch calendar: \(error.localizedDescription)"
            print("Error: \(error)")
        }
        
        isLoading = false
        
    }
    
    private func parseRawData(icsString: String, context: ModelContext) {
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
                if classObject.name == className {
                    foundClass = classObject
                }
            }
            
            if let foundClass = foundClass {
                foundClass.addAssignment(Assignment(name: conciseSummary, desc: desc, dueDate: dueDate, parentClass:  foundClass))
            } else {
                addClass(Class(name: className))
            }
        }
        updateContext(context)
        print(classes.count)
    }
    
    private func addClass(_ classObject: Class) {
        classes.append(classObject)
    }
    
    private func updateContext(_ context: ModelContext) {
        for classObj: Class in classes {
            context.insert(classObj)
            try? context.save()
        }
    }
    
    private func clearSwiftData() {
        
    }
}
