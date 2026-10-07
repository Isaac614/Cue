import SwiftUI
import SwiftData

struct UpcomingAssignments: View {
    
    let calendar = Calendar.current
    let today = Date()
    
    var nextSevenDays: [Date] {
        (1...7).compactMap { offset in
            calendar.date(byAdding: .day, value: offset, to: today)
        }
    }
    
    @Query(sort: \Class.userName, order: .forward) var classes: [Class]
    var upcomingAssignments: [Assignment] {
        classes
            .flatMap(\.upcomingAssignments)
            .sorted { a, b in
                if a.dueDate != b.dueDate {
                    return (a.dueDate ?? .distantPast) < (b.dueDate ?? .distantPast)
                }
                
                if a.className != b.className {
                    return (a.className) < (b.className)
                }
                
                return (a.name ?? "") < (b.name ?? "")
            }
    }
    
    var body: some View {
        LazyVStack(alignment: .leading, spacing: 38) {
            
            ForEach(nextSevenDays, id: \.self) { date in
                let assignmentsForDay = upcomingAssignments.filter { assignment in
                    guard let dueDate = assignment.dueDate else { return false }
                    return calendar.isDate(dueDate, inSameDayAs: date)
                }
                VStack(alignment: .leading) {
                    Text(calendar.isDateInTomorrow(date)
                         ? "Tomorrow"
                         : date.formatted(.dateTime.weekday(.wide)))
                        .font(.title)
                        .foregroundStyle(Color("TextColor"))
                        .fontWeight(.semibold)
                        .padding(.leading)
                    
                    VStack(alignment: .leading, spacing: 18) {
                        if assignmentsForDay.count > 0 {
                            ForEach(assignmentsForDay) { assignment in
                                NavigationLink {
                                    AssignmentDetailsView(assignment: assignment)
                                } label: {
                                    AssignmentListView(assignment: assignment, includeClass: true)
                                }
                                .navigationLinkIndicatorVisibility(.hidden)
                            }
                        } else {
                            Text("Nothing Due!")
                                .font(.subheadline)
                                .foregroundStyle(Color("SubheadlineColor"))
                                .padding(.leading)
                                .frame(maxWidth: .infinity, alignment: .center)
                        }
                    }
                }
            }
        }
    }
}
