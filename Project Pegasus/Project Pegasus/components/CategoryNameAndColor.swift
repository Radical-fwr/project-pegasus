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
    
    var body: some View {
        HStack {
            TextField("", text: $categoryName, prompt: Text(categoryName)
                .foregroundStyle(Color(colorScheme == .dark ? .black : .white))
                .font(Font.custom("HelveticaNeue", size: 30)))
            .font(Font.custom("HelveticaNeue", size: 30))
            .underline(color: Color(colorScheme == .dark ? .black : .white))
            .foregroundStyle(Color(colorScheme == .dark ? .black : .white).opacity(0.5))
            .multilineTextAlignment(.leading)
            Spacer()
            
            CircleChoseColorButton(showColorPicker: $showColorPicker)
        }
        
        Spacer().frame(height: 20)
        if showColorPicker {
            ColorPickerView(selectedColor: $selectedColor)
        }
    }
}

#Preview {
    AddNewCategory()
}
