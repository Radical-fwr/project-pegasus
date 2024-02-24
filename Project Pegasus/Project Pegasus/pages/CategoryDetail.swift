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
    
    var body: some View {
        
        VStack(alignment: .center, content: {
            HStack {
                Text(categoryName)
                    .font(.title)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundColor(.black)
                
                Spacer()
                Circle()
                    .strokeBorder(Color.black, lineWidth: 3)
                    .frame(width: 24, height: 24)
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
            .padding([.horizontal],25)
                        
            ScrollView{
                /*
                ForEach(0..<4) { _ in
                    CategoryWStats(
                        name: "Analisi 2",
                        color: categoryColor,
                        progress: 0.6,
                        gradient: gradient
                    )
                }
                .padding([.horizontal],25)*/
                ForEach(subCategories){ _subCategory in
                    CategoryWStats(
                        name: _subCategory.name.uppercased(),
                        color: categoryColor,
                        progress: _subCategory.progress,
                        gradient: gradient
                    )
                }
                .padding([.horizontal],25)
            }
        })
        .background(categoryColor.edgesIgnoringSafeArea(.all))
    }
}


#Preview {
    
    return CategoryDetail(categoryName: "Prova", categoryColor: .orange)
}
