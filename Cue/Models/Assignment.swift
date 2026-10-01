import Foundation
import SwiftData
import SwiftUI

@Model
final class Assignment {
    var icsUID: String
    var name: String?
    var desc: String?
    var dueDate: Date?
    var isComplete: Bool
    
    @Relationship(inverse: \Class.assignments)
    var parentClass: Class
    
    var red: Double? { parentClass.red }
    var green: Double? { parentClass.green }
    var blue: Double? { parentClass.blue }
    var opacity: Double? { parentClass.opacity }
    var className: String { parentClass.userName }
    var submissionStatus: String = "Not Complete"
    
    
    var formattedDate: String? {
        guard let dueDate = dueDate else { return nil }

        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: dueDate)
        let minute = calendar.component(.minute, from: dueDate)

        let formatter = DateFormatter()

        // Due today
        if calendar.isDateInToday(dueDate) {
            if hour != 0 || minute != 0 {
                formatter.dateFormat = "h:mm a"
                return formatter.string(from: dueDate).lowercased()
            }

            return "Today"
        }

        // Due on another day
        formatter.dateFormat = "EEE MM/dd"
        let dateString = formatter.string(from: dueDate)

        // Has a specific time
        if hour != 0 || minute != 0 {
            formatter.dateFormat = "h:mm a"
            let timeString = formatter.string(from: dueDate).uppercased()
            return "\(dateString)\n\(timeString)"
        }

        // No specific time
        return dateString
    }

    
    init(icsUID: String, name: String?, desc: String?, dueDate: Date?, parentClass: Class, isComplete: Bool = false) {
        self.icsUID = icsUID
        self.name = name
        self.desc = desc
        self.dueDate = dueDate
        self.parentClass = parentClass
        self.isComplete = isComplete
        submissionStatus = "Not Complete"
        updateSubmissionStatus()
    }
    
    func markStatus() {
        isComplete = !isComplete
        updateSubmissionStatus()
    }
    
    func updateSubmissionStatus() {
        let now = Date()
        submissionStatus = isComplete ?
        ((Calendar.current.isDateInToday(dueDate ?? .distantPast) || now <= dueDate ?? .distantPast) ? "Complete" : "Submitted Late") :
        ((!Calendar.current.isDateInToday(dueDate ?? .distantPast) || now >= dueDate ?? .distantPast) ? "Not Complete" : "Overdue")
    }
}
