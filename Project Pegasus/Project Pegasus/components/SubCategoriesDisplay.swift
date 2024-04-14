//
//  SubCategoriesDisplay.swift
//  Project Pegasus
//
//  Created by Lorenzo Vecchio on 15/01/24.
//

import SwiftUI
import SwiftData

struct SubCategoriesDisplay: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.modelContext) private var context
    var category: Category?
    @Binding var opened: Bool
    @State private var showAlert: Bool = false
    @State private var newSubcategoryName: String = ""
    @Query var subCategories: [SubCategory]
    @Binding var selectedSubCategory: SubCategory?
    
    func createNewSubCategory() {
        print("test")
        let newSubCategory = SubCategory(name: newSubcategoryName, parentCategory: category)
        context.insert(newSubCategory)
        do {
            try context.save()
            newSubcategoryName = ""
        } catch {
            print("Error saving context: \(error)")
        }
    }
    
    var body: some View {
        if let category = category {
            
            VStack{
                SubCategoriesButton(category: category, opened: $opened)
                if opened{
                    VStack(alignment:.leading){
                        ForEach(subCategories){subCategory in
                            Text(subCategory.name)
                            Divider().foregroundColor(Color(hex: category.color))
                        }
//                       
//                        Text("Organizzare consegne")
//                        Divider().foregroundColor(Color(hex: category.color))
//                        Text("Fare fatture")
//                        
                    }
                    .padding(.horizontal)
                    
                }
            }
            .padding(.vertical, opened ? 8: 0)
            
            .background(LinearGradient(colors: [Color(hex: category.color).opacity(0.1), Color(hex: category.color).opacity(0.6)], startPoint: .leading, endPoint: .trailing))
            .cornerRadius(opened ? 10 : 0)
            .padding(.trailing, opened ? 30 : 0)
            //.offset(y: 70)
           // .opacity(opened ? 1.00 : 0.00)
           // ZStack {
                
               
                //ZStack {
                   // ZStack {
                        /*
                        ScrollView {
                            VStack {
                                Spacer()
                                HStack {
                                    Text("ALL")
                                        .font(Font.custom("HelveticaNeue", size: 15))
                                        .foregroundColor(colorScheme == .dark ? .white : .black)
                                }
                                Rectangle()
                                    .frame(width: 170, height: 1)
                                    .background(Color(hex: category.color))
                                    .border(Color(hex: category.color).opacity(0.6))
                                ForEach(subCategories) { subCategory in
                                    if subCategory.parentCategory!.id == category.id {
                                        Spacer()
                                        HStack {
                                            Text(subCategory.name)
                                                .font(Font.custom("HelveticaNeue", size: 15))
                                                .foregroundColor(colorScheme == .dark ? .white : .black)
                                                
                                            Spacer()
                                        }
                                        .padding(.leading, 15)
                                        .onTapGesture{
                                            selectedSubCategory = subCategory
                                        }
                                        Rectangle()
                                            .frame(width: 170, height: 1)
                                            .background(Color(hex: category.color))
                                            .border(Color(hex: category.color).opacity(0.6))
                                    }
                                }
                                Spacer()
                                HStack {
                                    Text("+")
                                        .foregroundColor(colorScheme == .dark ? .white : .black)
                                        .font(Font.custom("HelveticaNeue", size: 20))
                                        .padding(.leading, 15)
                                        .onTapGesture{
                                            showAlert.toggle()
                                        }
                                        .alert("Nuova sottocategoria", isPresented: $showAlert) {
                                            TextField("Nome", text: $newSubcategoryName).foregroundColor(.black)
                                            Button("Conferma") { createNewSubCategory() }.disabled(newSubcategoryName.isEmpty)
                                            Button("Annulla", role: .cancel) { }
                                        } message: {
                                            Text("Stai creando una nuova sottocategoria della categoria: " + category.name.uppercased() + ". Come la vuoi chiamare?")
                                        }
                                }
                            }
                        }
                        .frame(width: UIScreen.main.bounds.width*0.6, height: 90)*/
                    //}
                    
//                    .frame(width: UIScreen.main.bounds.width*0.6, height: 90)
//                    .cornerRadius(5)
//                    .overlay(
//                        RoundedRectangle(cornerRadius: 5)
//                            .stroke(Color(hex: category.color).opacity(0.6), lineWidth: 1)
//                    )
                //}
               
           // }
            

        } else {
            ZStack {
                SubCategoriesButton(category: category, opened: $opened)
                
                ZStack {
                    EmptyView()
                }
                .frame(width: UIScreen.main.bounds.width*0.6, height: 90)
                .offset(y: 70)
            }
            
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
