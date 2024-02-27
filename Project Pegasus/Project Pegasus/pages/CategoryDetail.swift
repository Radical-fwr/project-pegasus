//
//  CategoryDetail.swift
//  Project Pegasus
//
//  Created by Giovanni Ercolano on 24/02/24.
//

import SwiftUI
import SwiftData

enum FilterType {
    case alphabetical, efficiency,date
}

struct CategoryDetail: View {
    let categoryId: String
    let categoryName: String
    let categoryColor: Color!
    let gradient = LinearGradient(gradient: Gradient(colors: [Color.black, Color.black.opacity(0.5)]), startPoint: .leading, endPoint: .trailing)
    @Query var subCategories : [SubCategory]
    @State private var showingFilter = false
    @State private var selectedFilter: FilterType = .alphabetical
    
    private var filteredSubCategories: [SubCategory] {
        
        switch selectedFilter {
        case .alphabetical:
            return subCategories.sorted(by: { $0.name < $1.name })
        case .efficiency:
            return subCategories.sorted(by: { $0.progress > $1.progress })
        case .date:
            return subCategories.sorted(by: {
                $0.mostRecentSessionDate ?? Date.distantPast > $1.mostRecentSessionDate ?? Date.distantPast
            })
        }
    }
    
    
    
    
    var body: some View {
        
        VStack(alignment: .center, content: {
            HStack {
                Text(categoryName)
                    .font(.title.bold())
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundColor(.black)
                
                Spacer()
                Circle()
                    .strokeBorder(Color.black, lineWidth: 3)
                    .frame(width: 28, height: 28)
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
            
            Button(action: {
                showingFilter = true
            }) {
                Text("Ordina per")
                Image(systemName: "arrow.up.arrow.down")
                    .font(.caption)
            }
            .foregroundColor(.black)
            .frame(maxWidth: .infinity, alignment: .leading)
            
            ScrollView{
                /*
                 ForEach(0..<10) { _ in
                 CategoryWStats(
                 name: "Analisi 2",
                 color: categoryColor,
                 progress: 0.6,
                 gradient: gradient
                 )
                 }*/
                
                ForEach(filteredSubCategories){ _subCategory in
                    if _subCategory.parentCategory!.id == categoryId {
                        CategoryWStats(
                            name: _subCategory.name.uppercased(),
                            color: categoryColor,
                            progress: _subCategory.progress,
                            gradient: gradient
                        )
                    }
                }
                
                
            }
        })
        .padding(.horizontal,25)
        .background(categoryColor.edgesIgnoringSafeArea(.all))
        .sheet(isPresented: $showingFilter) {
            FilterSheetView(selectedFilter: $selectedFilter)
                .presentationDetents([.height(240)])
                .presentationBackground(.clear)
        }
    }
}


#Preview {
    
    return CategoryDetail(categoryId: "12345", categoryName: "Prova", categoryColor: .orange)
}
