//
//  AddCategory_2.0.swift
//  Project Pegasus
//
//  Created by Giovanni Ercolano on 29/02/24.
//

import SwiftUI

struct AddNewCategory: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Environment(\.modelContext) private var context
    @State private var categoryName: String = "CATEGORIA"
    @State private var showColorPicker: Bool = false
    @State private var selectedColor: Color = Color(hex: "A8A8A8")
    
    var body: some View {
        NavigationStack {
            ZStack {
                if showColorPicker{
                    Color.clear
                        .contentShape(Rectangle())
                        .onTapGesture {
                            withAnimation {
                                showColorPicker = false
                            }
                        }
                }
                VStack {
                    HStack {
                        R_button()
                            .foregroundColor(colorScheme == .dark ? .black : .white)
                            .onTapGesture {
                                onSave()
                                self.presentationMode.wrappedValue.dismiss()
                            }
                        Spacer()
                    }
                    
                    CategoryNameAndColor(categoryName: $categoryName, showColorPicker: $showColorPicker, selectedColor: $selectedColor)
                        .onSubmit {
                            onSave()
                        }
                    Spacer()
                }.padding(25)
            }.background(Color(selectedColor).edgesIgnoringSafeArea(.all))
        }
        .navigationBarTitle("")
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
    }
    
    func onSave() {
        if categoryName != ""{
            if(categoryName != "CATEGORIA" && selectedColor != .gray){
                do {
                    
                    let newCategory = Category(name:categoryName , color: try selectedColor.toHex())
                    context.insert(newCategory)
                    try context.save()
                } catch {
                    print("Error saving context: \(error)")
                }
            }
        }
    }
    
}



#Preview {
    AddNewCategory()
}
