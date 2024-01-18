//
//  SubCategoriesDisplay.swift
//  Project Pegasus
//
//  Created by Lorenzo Vecchio on 15/01/24.
//

import SwiftUI
import SwiftData

struct SubCategoriesDisplay: View {
    @Environment(\.modelContext) private var context
    var category: Category?
    @State private var opened: Bool = false
    @Query var subCategories: [SubCategory]
    @State var selectedSubCategory: SubCategory?
    
    var body: some View {
        if let category = category {
            VStack {
                SubCategoriesButton(category: category, opened: $opened)
                    .overlay {
                        if opened {
                            ZStack {
                                ZStack {
                                    ScrollView {
                                        VStack {
                                            Spacer()
                                            HStack {
                                                Text("ALL")
                                                    .font(Font.custom("HelveticaNeue", size: 15))
                                            }
                                            Rectangle()
                                                .frame(width: 170, height: 1)
                                                .background(Color(hex: category.color))
                                                .border(Color(hex: category.color))
                                            ForEach(subCategories) { subCategory in
                                                if subCategory.parentCategory!.id == category.id {
                                                    Spacer()
                                                    HStack {
                                                        Text(subCategory.name)
                                                            .font(Font.custom("HelveticaNeue", size: 15))
                                                            
                                                        Spacer()
                                                    }
                                                    .padding(.leading, 15)
                                                    Rectangle()
                                                        .frame(width: 170, height: 1)
                                                        .background(Color(hex: category.color))
                                                        .border(Color(hex: category.color))
                                                }
                                            }
                                            Spacer()
                                            HStack {
                                                Text("+")
                                                    .font(Font.custom("HelveticaNeue", size: 20))
                                                    .padding(.leading, 15)
                                            }
                                        }
                                    }
                                    .frame(width: 200, height: 90)
                                }
                                .background(LinearGradient(colors: [Color(hex: category.color).opacity(0.1), Color(hex: category.color).opacity(0.6)], startPoint: .leading, endPoint: .trailing))
                                .frame(width: 200, height: 90)
                                .cornerRadius(5)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 5)
                                        .stroke(Color(hex: category.color), lineWidth: 1)
                                )
                            }
                            .offset(y: 76)
                        }
                    }
            }

        } else {
            SubCategoriesButton(category: category, opened: $opened)
        }
    }
}

//#Preview {
//    let container = try! ModelContainer(for: Category.self, User.self, Session.self, SubCategory.self)
//    let category: Category = Category(name: "work", color: "F6DE00")
//    let subCategory: SubCategory = SubCategory(name: "Rispondere a mail", parentCategory: category)
//    container.mainContext.insert(category)
//    container.mainContext.insert(subCategory)
//    let fetchDescriptor = FetchDescriptor<Category>()
//    return SubCategoriesDisplay(category: container.mainContext.fetch(fetchDescriptor).first)
//        .modelContainer(container)
//}
