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
    var className: String? { parentClass.userName }
    
    
    var formattedDate: String? {
        guard let dueDate = dueDate else { return nil }
        
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: dueDate)
        let minute = calendar.component(.minute, from: dueDate)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE MM/dd"  // day of week + month/day
        
        var result = formatter.string(from: dueDate)
        
        // Only append time if it's not 00:00
        if hour != 0 || minute != 0 {
            formatter.dateFormat = "hh:mm a"  // 12-hour format
            result += " due by " + formatter.string(from: dueDate)
        }
        
        return result
    }

    
    init(icsUID: String, name: String?, desc: String?, dueDate: Date?, parentClass: Class, isComplete: Bool = false) {
        self.icsUID = icsUID
        self.name = name
        self.desc = desc
        self.dueDate = dueDate
        self.parentClass = parentClass
        self.isComplete = isComplete
    }
    
    func markStatus() {
        isComplete = !isComplete
    }
}
