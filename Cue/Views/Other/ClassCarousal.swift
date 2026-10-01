import SwiftUI
import SwiftData

struct ClassCarousal: View {
    
    let manager: ICSManager
    @Environment(\.modelContext) var modelContext
    @Query(sort: \Class.userName, order: .forward) var classes: [Class]
    @Binding var swipedClass: Class?
    @State var isExpanded: Bool = false
    
    var body: some View {
        VStack() {
            Text("Classes")
                .font(.title)
                .foregroundStyle(Color("TextColor"))
                .fontWeight(.semibold)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            if !isExpanded {
                ScrollView(.horizontal) {
                    HStack(spacing: 15) {
                        ForEach(classes) { classObject in
                            NavigationLink {
                                ClassView(classObject: classObject)
                            } label: {
                                ClassListView(classObject: classObject)
                            }
                            .navigationLinkIndicatorVisibility(.hidden)
                        }
                    }
                    .padding(.bottom, 13)
                    .padding(.horizontal, 5)
                    .padding(.top, 5)
                }
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
                            ClassListView(classObject: classObject)
                        }
                        .navigationLinkIndicatorVisibility(.hidden)
                    }
                }
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



    //            ForEach(classes) { classObject in
    //                NavigationLink {
    //                    ClassView(classObject: classObject)
    //                } label: {
    //                    ClassListView(classObject: classObject)
    //                        .padding(.vertical, 12)
    //                }
    //                .listRowInsets(EdgeInsets())
    //                .listRowSeparator(.hidden)
    //                .listRowBackground(Color.clear)
    //                .navigationLinkIndicatorVisibility(.hidden)
    //                .swipeActions(edge: .trailing) {
    //                    Button {
    //                        swipedClass = classObject
    //
    //                    } label: {
    //                        Image(systemName: "paintpalette")
    //                    }
    //                    .tint(Color("AccentColor"))
    //
    //                    Button(role: .destructive) {
    //                        deleteClass(classObject)
    //
    //                    } label: {
    //                        Text("Delete")
    //                    }
    //                    .tint(Color("WarningColor"))
    //                }
    //            }
