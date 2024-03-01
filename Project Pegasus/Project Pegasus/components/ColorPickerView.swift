//
//  ColorPickerView.swift
//  Project Pegasus
//
//  Created by Giovanni Ercolano on 01/03/24.
//

import SwiftUI

struct ColorPickerView: View {
    @Environment(\.colorScheme) var colorScheme
    let colors: [Color] = [.orange, .yellow, .green, .cyan ,.pink,.indigo,.brown]
    @Binding var selectedColor: Color
    
    let columns = [
        GridItem(.adaptive(minimum:60))
    ]
    
    var body: some View {
        LazyVGrid(columns: columns) {

            ForEach(colors, id: \.self) { color in
                Rectangle()
                    .fill(color)
                    .cornerRadius(20)
                    .frame(width: 50, height: 50)
                    .onTapGesture {
                        selectedColor = color
                    }
                    .padding(20)
                    .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 10)
            }
        }
        .padding(.vertical,30)
        .padding(.horizontal,25)
        .background(RoundedRectangle(cornerRadius: 25).fill(Color(colorScheme == .dark ? .black : .white)))
    }
}


