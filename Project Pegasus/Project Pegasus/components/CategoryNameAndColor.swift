//
//  CategoryNameAndColor.swift
//  Project Pegasus
//
//  Created by Giovanni Ercolano on 01/03/24.
//

import SwiftUI

struct CategoryNameAndColor: View {
    @Environment(\.colorScheme) var colorScheme
    @Binding var categoryName: String 
    @Binding var showColorPicker: Bool
    @Binding var selectedColor: Color
    @FocusState private var categoryFieldIsFocused: Bool
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    TextField("", text: $categoryName, prompt: Text(categoryName))
                        .focused($categoryFieldIsFocused)
                        .font(Font.custom("HelveticaNeue", size: 30))
                        .underline(color: categoryFieldIsFocused ? Color(colorScheme == .dark ? .black : .white) : Color.clear)
                        .foregroundStyle(Color(colorScheme == .dark ? .black : .white).opacity(0.5))
                        .multilineTextAlignment(.leading)
                        .textInputAutocapitalization(.never)
                        .disableAutocorrection(true)
                        .onTapGesture {
                            withAnimation{
                                categoryFieldIsFocused.toggle()
                            }
                        }
                    Spacer()
                    
                    CircleChoseColorButton(showColorPicker: $showColorPicker)
                }
                Spacer().frame(height: 20)
                if showColorPicker {
                    ColorPickerView(selectedColor: $selectedColor)
                }
            }
        }
        
    }
}

#Preview {
    AddNewCategory()
}
