//
//  SubCategoriesButton.swift
//  Project Pegasus
//
//  Created by Lorenzo Vecchio on 15/01/24.
//

import SwiftUI
import SwiftData

struct SubCategoriesButton: View {
    @Environment(\.colorScheme) var colorScheme
    var category: Category?
    @Binding var opened: Bool
    @State private var chevronRotation: Double = 0
    
    var body: some View {
        if let category = category {
            Button(action: {
                opened.toggle()
            }) {
                ZStack{
                    HStack{
                        Text(category.name.uppercased())
                            .font(Font.custom("HelveticaNeue", size: 22))
                            .foregroundColor(Color(hex: category.color))
                            .fontWeight(.light)
                            .padding()
                        
                        
                        Spacer()
                        
                        HStack{
                            
                            Text("All")
                                .font(Font.custom("HelveticaNeue", size: 22))
                                .foregroundColor(colorScheme == .dark ? .white : .black)
                            
                            Image(systemName: "chevron.right")
                                .rotationEffect(Angle(degrees: chevronRotation))
                                .font(.system(size: 20))
                                .onChange(of: opened) {
                                    withAnimation(.easeInOut(duration: 0.2)) {
                                        if opened {
                                            chevronRotation = 90
                                        } else {
                                            chevronRotation = 0
                                        }
                                    }
                                }
                        }
                        .foregroundColor(colorScheme == .dark ? .white : .black)
                        .padding()
                    }
                    HStack{
                        
                    }
                    .frame(height: 40)
                    .background(LinearGradient(colors: [Color(hex: category.color).opacity(0.1), Color(hex: category.color).opacity(0.6)], startPoint: .leading, endPoint: .trailing))
                }
                .frame(height: 40)
                .cornerRadius(5)
                .overlay(
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(Color(hex: category.color).opacity(opened ? 0 : 0.6), lineWidth: 1)
                        
                )
            }
        } else {
            HStack {
                Text("Select a category")
                    .font(Font.custom("HelveticaNeue", size: 22))
                    .foregroundColor(colorScheme == .dark ? .white : .black)
                    .fontWeight(.light)
                    .padding()
            }
            .frame( height: 40)
            .cornerRadius(5)
            .overlay(
                RoundedRectangle(cornerRadius: 5)
                    .stroke(colorScheme == .dark ? .white : .black, lineWidth: 1)
            )
        }
    }
}

//#Preview {
//    let container = try! ModelContainer(for: Category.self, User.self, Session.self, SubCategory.self)
//    let category: Category = Category(name: "work", color: "F6DE00")
//    let subCategory: SubCategory = SubCategory(name: "Rispondere a mail", parentCategory: category)
//    container.mainContext.insert(category)
//    container.mainContext.insert(subCategory)
//    return SubCategoriesButton(category: Category(name: "work", color: "F6DE00"))
//        .modelContainer(container)
//}
