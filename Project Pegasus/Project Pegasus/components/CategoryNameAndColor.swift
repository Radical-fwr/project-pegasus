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
                .underline()
                .font(Font.custom("HelveticaNeue", size: 30)))
            .font(Font.custom("HelveticaNeue", size: 30))
            .foregroundStyle(Color(colorScheme == .dark ? .black : .white))
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
