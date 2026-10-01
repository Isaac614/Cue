import SwiftUI
import SwiftData

struct DueToday: View {
    
    @Query(sort: \Class.userName, order: .forward) var classes: [Class]
    var dueAssignments: [Assignment] {
        classes
            .flatMap(\.todaysAssignments)
    }
    
    
    var body: some View {
        LazyVStack(spacing: 18) {
            Section("Due Today") {
                if dueAssignments.isEmpty {
                    Text("You're all caught up!")
                        .font(.body)
                        .foregroundColor(Color.gray)
                        .listRowInsets(EdgeInsets())
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.clear)
                } else {
                    ForEach(dueAssignments) { assignment in
                        NavigationLink {
                            AssignmentDetailsView(assignment: assignment)
                        } label: {
                            AssignmentListView(assignment: assignment, includeClass: true)
                        }
                        .listRowInsets(EdgeInsets())
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.clear)
                        .navigationLinkIndicatorVisibility(.hidden)
                    }
                }
            }
        }
    }
}
