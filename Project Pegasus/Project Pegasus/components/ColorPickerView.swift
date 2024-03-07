//
//  ColorPickerView.swift
//  Project Pegasus
//
//  Created by Giovanni Ercolano on 01/03/24.
//

import SwiftUI

struct ColorPickerView: View {
    @Environment(\.colorScheme) var colorScheme
    let colors: [Color] = [.orange, .yellow, .green, .cyan, .pink, .indigo, .brown]
    @Binding var selectedColor: Color
    let columns = [
        GridItem(.adaptive(minimum: 60))
    ]
    
    var body: some View {
        LazyVGrid(columns: columns) {
            ForEach(colors, id: \.self) { color in
                Rectangle()
                    .fill(LinearGradient(gradient: Gradient(colors: [color, color.opacity(0.7)]), startPoint: .leading, endPoint: .trailing))
                    .cornerRadius(20)
                    .frame(width: 48, height: 48)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(selectedColor == color ? Color.white : Color.clear, lineWidth: 3)
                    )
                    .onTapGesture {
                        selectedColor = color
                    }
                    .padding(20)
                    .shadow(color: .black.opacity(0.2), radius: 12, x: 0, y: 4)
            }
        }
        .padding(.vertical,30)
        .padding(.horizontal,25)
        .background(RoundedRectangle(cornerRadius: 25).fill(LinearGradient(gradient: Gradient(colors: [Color(colorScheme == .dark ? .black : .white), Color(colorScheme == .dark ? .black : .white).opacity(0.7)]), startPoint: .leading, endPoint: .trailing)))
    }
}



#Preview {
    AddNewCategory()
}

