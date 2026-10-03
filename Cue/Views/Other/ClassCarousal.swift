import SwiftUI
import SwiftData

struct ClassCarousal: View {
    
    let manager: ICSManager
    @Environment(\.modelContext) var modelContext
    @Query(sort: \Class.userName, order: .forward) var classes: [Class]
    @Binding var classToEdit: Class?
    @State var isExpanded: Bool = false
    
    var body: some View {
        VStack() {
            Button {
                withAnimation {
                    isExpanded = !isExpanded
                }
            } label: {
                HStack {
                    Text("Classes")
                        .font(.title)
                        .foregroundStyle(Color("TextColor"))
                        .fontWeight(.semibold)
                    Image(systemName: isExpanded ? "chevron.down" : "chevron.right")
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            if !isExpanded {
                ScrollView(.horizontal) {
                    HStack(spacing: 15) {
                        ForEach(classes) { classObject in
                            NavigationLink {
                                ClassView(classObject: classObject)
                            } label: {
                                ClassListView(
                                    classObject: classObject,
                                    onEdit: {
                                        classToEdit = classObject
                                    },
                                    onDelete: {
                                        modelContext.delete(classObject)
                                    }
                                )
                            }
                            .navigationLinkIndicatorVisibility(.hidden)
                        }
                    }
                    .padding(.bottom, 13)
                    .padding(.horizontal, 5)
                    .padding(.top, 5)
                }
                .transition(
                    .asymmetric(
                        insertion: .move(edge: .leading),
                        removal: .move(edge: .trailing)
                    )
                )
            } else {
                LazyVGrid(
                    columns: [
                        GridItem(.flexible(), spacing: 15),
                        GridItem(.flexible(), spacing: 15)
                    ],
                    spacing: 15
                ) {
                    ForEach(classes) { classObject in
                        NavigationLink {
                            ClassView(classObject: classObject)
                        } label: {
                            ClassListView(
                                classObject: classObject,
                                onEdit: {
                                    classToEdit = classObject
                                },
                                onDelete: {
                                    modelContext.delete(classObject)
                                }
                            )
                        }
                        .navigationLinkIndicatorVisibility(.hidden)
                    }
                }
                .transition(
                    .asymmetric(
                        insertion: .move(edge: .leading),
                        removal: .move(edge: .trailing)
                    )
                )
            }
        }
        .padding(0)
        .background(Color("BackgroundColor"))
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
