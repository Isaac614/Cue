import Foundation
import SwiftData
import SwiftUI

@Model
final class Assignment {
    var name: String?
    var desc: String?
    var dueDate: Date?
    var isComplete: Bool
    
    
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

    
    init(name: String?, desc: String?, dueDate: Date?, isComplete: Bool = false) {
        self.name = name
        self.desc = desc
        self.dueDate = dueDate
        self.isComplete = isComplete
    }
    
    func markStatus() {
        isComplete = !isComplete
    }
}
