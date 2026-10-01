import SwiftUI
import SwiftData

struct UpcomingAssignments: View {
    
    @Query(sort: \Class.userName, order: .forward) var classes: [Class]
    var upcomingAssignments: [Assignment] {
        classes
            .flatMap(\.upcomingAssignments)
            .sorted { a, b in
                if a.dueDate != b.dueDate {
                    return (a.dueDate ?? .distantPast) < (b.dueDate ?? .distantPast)
                }
                
                if a.className != b.className {
                    return (a.className ?? "") < (b.className ?? "")
                }
                
                return (a.name ?? "") < (b.name ?? "")
            }
    }
    
    var body: some View {
        if upcomingAssignments.isEmpty {
            Text("You're all caught up!")
                .font(.body)
                .foregroundColor(Color.gray)
                .listRowInsets(EdgeInsets())
                .listRowSeparator(.hidden)
                .listRowBackground(Color.clear)
        } else {
            ForEach(upcomingAssignments) { assignment in
                NavigationLink {
                    AssignmentDetailsView(assignment: assignment)
                } label: {
                    AssignmentListView(assignment: assignment, includeClass: true)
//                        .padding(.horizontal)
                        .padding(.vertical, 9)
                }
                .listRowInsets(EdgeInsets())
                .listRowSeparator(.hidden)
                .listRowBackground(Color.clear)
                .navigationLinkIndicatorVisibility(.hidden)
            }
        }
    }
}



//Text("Upcoming")
//    .font(.title)
//    .bold()
//    .padding(.horizontal)
//    .listRowInsets(EdgeInsets())
//    .listRowSeparator(.hidden)
//    .listRowBackground(Color.clear)
