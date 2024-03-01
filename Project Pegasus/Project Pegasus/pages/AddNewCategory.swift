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
    @State private var selectedColor: Color = .gray
    
    var body: some View {
        NavigationStack {
            ZStack {
                
                VStack {
                    HStack {
                        R_button()
                            .foregroundColor(colorScheme == .dark ? .black : .white)
                            .onTapGesture {
                                //saveCategory()
                                self.presentationMode.wrappedValue.dismiss()
                            }
                        Spacer()
                    }
                    
                    CategoryNameAndColor(categoryName: $categoryName, showColorPicker: $showColorPicker, selectedColor: $selectedColor)
                        .onSubmit {
                            saveCategory()
                            
                        }
                    Spacer()
                    
                }.padding(25)
            }.background(Color(selectedColor).edgesIgnoringSafeArea(.all))
        }
        .navigationBarTitle("")
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
    }
    
    func saveCategory() {
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



#Preview {
    AddNewCategory()
}
