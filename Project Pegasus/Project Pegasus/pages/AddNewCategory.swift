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
    @State private var categoryName: String = ""
    @State private var showColorPicker: Bool = false
    @State private var selectedColor: Color = .gray
    
    var body: some View {
        NavigationStack {
            ZStack {
                
                VStack {
                    HStack {
                        R_button()
                            .foregroundColor(colorScheme == .dark ? .white : .black)
                            .onTapGesture {
                                self.presentationMode.wrappedValue.dismiss()
                            }
                        Spacer()
                    }
                    
                    HStack {
                        TextField("", text: $categoryName, prompt: Text("CATEGORIA")
                            .foregroundStyle(Color(colorScheme == .dark ? .white : .black))
                            .underline()
                            .font(Font.custom("HelveticaNeue", size: 30)))
                        .font(Font.custom("HelveticaNeue", size: 30))
                        .multilineTextAlignment(.leading)
                        Spacer()
                        
                        CircleChoseColorButton(showColorPicker: $showColorPicker)
                    }
                    
                    Spacer().frame(height: 20)
                    if showColorPicker {
                        ColorPickerView(selectedColor: $selectedColor)
                    }
                    Spacer()
                }.padding(25)
            }.background(selectedColor.edgesIgnoringSafeArea(.all))
        }
        .navigationBarTitle("")
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
    }
}




#Preview {
    AddNewCategory()
}
