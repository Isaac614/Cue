import SwiftUI
import SwiftData

struct ClassCarousal: View {
    
    let manager: ICSManager
    @Environment(\.modelContext) var modelContext
    @Query(sort: \Class.userName, order: .forward) var classes: [Class]
    @Binding var swipedClass: Class?
    
    var body: some View {
        Section("Classes") {
            
            ForEach(classes) { classObject in
                NavigationLink {
                    ClassView(classObject: classObject)
                } label: {
                    ClassListView(classObject: classObject)
                        .padding(.vertical, 12)
                }
                .listRowInsets(EdgeInsets())
                .listRowSeparator(.hidden)
                .listRowBackground(Color.clear)
                .navigationLinkIndicatorVisibility(.hidden)
                .swipeActions(edge: .trailing) {
                    Button {
                        swipedClass = classObject
                        
                    } label: {
                        Image(systemName: "paintpalette")
                    }
                    .tint(Color("AccentColor"))
                    
                    Button(role: .destructive) {
                        deleteClass(classObject)
                        
                    } label: {
                        Text("Delete")
                    }
                    .tint(Color("WarningColor"))
                }
            }
        }
    }
    
    
    
    
    private func deleteClass(_ classItem: Class) {
        // Remove from context
        modelContext.delete(classItem)
        
        // Save changes
        do {
            try modelContext.save()
        } catch {
            print("Failed to delete class: \(error)")
        }
    }
}
