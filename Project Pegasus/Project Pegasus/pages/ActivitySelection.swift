////
////  ActivitySelection.swift
////  Project Pegasus
////
////  Created by Hasan on 31/03/2024.
////
//
//import SwiftUI
//import SwiftData
//struct ActivitySelection: View {
//    @Environment(\.colorScheme) var colorScheme
//    @Environment(\.modelContext) private var context
//    var category: Category?
//    @Binding var opened: Bool
//    @State private var showAlert: Bool = false
//    @State private var newSubcategoryName: String = ""
//    @Query var subCategories: [SubCategory]
//    @Binding var selectedSubCategory: SubCategory?
//    
//    
//    
//    var body: some View {
//        if let category = category {
//            ZStack {
//                SubCategoriesButton(category: category, opened: $opened)
//               
//                ZStack {
//                    ZStack {
//                        ScrollView {
//                            VStack {
//                                Spacer()
//                                HStack {
//                                    Text("ALL")
//                                        .font(Font.custom("HelveticaNeue", size: 15))
//                                        .foregroundColor(colorScheme == .dark ? .white : .black)
//                                }
//                                Rectangle()
//                                    .frame(width: 170, height: 1)
//                                    .background(Color(hex: category.color))
//                                    .border(Color(hex: category.color).opacity(0.6))
//                                ForEach(subCategories) { subCategory in
//                                    if subCategory.parentCategory!.id == category.id {
//                                        Spacer()
//                                        HStack {
//                                            Text(subCategory.name)
//                                                .font(Font.custom("HelveticaNeue", size: 15))
//                                                .foregroundColor(colorScheme == .dark ? .white : .black)
//                                                
//                                            Spacer()
//                                        }
//                                        .padding(.leading, 15)
//                                        .onTapGesture{
//                                            selectedSubCategory = subCategory
//                                        }
//                                        Rectangle()
//                                            .frame(width: 170, height: 1)
//                                            .background(Color(hex: category.color))
//                                            .border(Color(hex: category.color).opacity(0.6))
//                                    }
//                                }
//                                Spacer()
//                                HStack {
//                                    Text("+")
//                                        .foregroundColor(colorScheme == .dark ? .white : .black)
//                                        .font(Font.custom("HelveticaNeue", size: 20))
//                                        .padding(.leading, 15)
//                                        .onTapGesture{
//                                            showAlert.toggle()
//                                        }
//                                        .alert("Nuova sottocategoria", isPresented: $showAlert) {
//                                            TextField("Nome", text: $newSubcategoryName).foregroundColor(.black)
//                                            Button("Conferma") { createNewSubCategory() }.disabled(newSubcategoryName.isEmpty)
//                                            Button("Annulla", role: .cancel) { }
//                                        } message: {
//                                            Text("Stai creando una nuova sottocategoria della categoria: " + category.name.uppercased() + ". Come la vuoi chiamare?")
//                                        }
//                                }
//                            }
//                        }
//                        .frame(width: UIScreen.main.bounds.width*0.6, height: 90)
//                    }
//                    .background(LinearGradient(colors: [Color(hex: category.color).opacity(0.1), Color(hex: category.color).opacity(0.6)], startPoint: .leading, endPoint: .trailing))
//                    .frame(width: UIScreen.main.bounds.width*0.6, height: 90)
//                    .cornerRadius(5)
//                    .overlay(
//                        RoundedRectangle(cornerRadius: 5)
//                            .stroke(Color(hex: category.color).opacity(0.6), lineWidth: 1)
//                    )
//                }
//                .offset(y: 70)
//                .opacity(opened ? 1.00 : 0.00)
//            }
//            
//
//        } else {
//            ZStack {
//                SubCategoriesButton(category: category, opened: $opened)
//                
//                ZStack {
//                    EmptyView()
//                }
//                .frame(width: UIScreen.main.bounds.width*0.6, height: 90)
//                .offset(y: 70)
//            }
//            
//        }
//    }
//}
//
//#Preview {
//    ActivitySelection()
//}
