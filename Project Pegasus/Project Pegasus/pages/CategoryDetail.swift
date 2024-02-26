//
//  CategoryDetail.swift
//  Project Pegasus
//
//  Created by Giovanni Ercolano on 24/02/24.
//

import SwiftUI
import SwiftData

struct CategoryDetail: View {
    let categoryName: String
    let categoryColor: Color!
    let gradient = LinearGradient(gradient: Gradient(colors: [Color.black, Color.black.opacity(0.5)]), startPoint: .leading, endPoint: .trailing)
    @Query var subCategories : [SubCategory]
    @State private var showingFilter = false
    
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
            
            Button("Ordina per"){
                showingFilter = true
            }
            .foregroundColor(.black)
            .frame(maxWidth: .infinity, alignment: .leading)
            .sheet(isPresented: $showingFilter, content: {
                FilterSheetView()
                    .presentationDetents([.height(240)])
                    .presentationBackground(.clear)
            })
            
            ScrollView{
                
                ForEach(0..<10) { _ in
                    CategoryWStats(
                        name: "Analisi 2",
                        color: categoryColor,
                        progress: 0.6,
                        gradient: gradient
                    )
                }
                /*
                 ForEach(subCategories){ _subCategory in
                 CategoryWStats(
                 name: _subCategory.name.uppercased(),
                 color: categoryColor,
                 progress: _subCategory.progress,
                 gradient: gradient
                 )
                 }
                 */
            }
        })
        .padding(.horizontal,25)
        .background(categoryColor.edgesIgnoringSafeArea(.all))
    }
}


struct FilterSheetView: View {
    
    let gradient = LinearGradient(gradient: Gradient(colors: [Color.black, Color.black.opacity(0.5)]), startPoint: .leading, endPoint: .trailing)
    
    
    var body: some View {
        VStack(spacing: 0, content: {
            Text("DATA")
                .font(.title2.bold())
                .foregroundColor(.white)
            Text("A-Z")
                .font(.title2.bold())
                .padding(.top,15)
                .foregroundColor(.white)
            Text("EFFICIENZA")
                .font(.title2.bold())
                .padding(.top,15)
                .foregroundColor(.white)
            Text("Cancel")
                .font(.callout.bold())
                .padding(.top,15)
                .foregroundColor(.gray)
        })
        .frame(maxWidth: .infinity,maxHeight: .infinity)
        .frame(height: 380)
        .background(gradient)
        .clipShape(.rect(cornerRadius: 30))
    }
}

#Preview {
    
    return CategoryDetail(categoryName: "Prova", categoryColor: .orange)
}
