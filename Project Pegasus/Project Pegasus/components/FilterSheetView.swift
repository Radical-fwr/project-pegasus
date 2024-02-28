//
//  FilterSheetView.swift
//  Project Pegasus
//
//  Created by Giovanni Ercolano on 27/02/24.
//

import SwiftUI

struct FilterSheetView: View {
    @Binding var selectedFilter: FilterType
    @Environment(\.presentationMode) var presentationMode
    
    let gradient = LinearGradient(gradient: Gradient(colors: [Color.black, Color.black.opacity(0.8)]), startPoint: .leading, endPoint: .trailing )
    
    var body: some View {
        VStack(spacing: 0) {
            
            FilterButton(title: "DATA", filterType: .date, selectedFilter: $selectedFilter)
            FilterButton(title: "A-Z", filterType: .alphabetical, selectedFilter: $selectedFilter)
            FilterButton(title: "EFFICIENZA", filterType: .efficiency, selectedFilter: $selectedFilter)
            
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Text("Annulla")
                    .font(.callout.bold())
                    .padding(.top,15)
                    .foregroundColor(.white.opacity(0.5))
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .frame(height: 380)
        .background(gradient)
        .cornerRadius(30)
    }
}



#Preview {
    
    return CategoryDetail(categoryId: "12345", categoryName: "Prova", categoryColor: .orange)
}
