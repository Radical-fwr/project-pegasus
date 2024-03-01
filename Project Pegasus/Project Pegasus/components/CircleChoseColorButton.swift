//
//  CircleChoseColorButton.swift
//  Project Pegasus
//
//  Created by Giovanni Ercolano on 01/03/24.
//

import SwiftUI

struct CircleChoseColorButton: View {
    @Binding var showColorPicker: Bool
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        Circle()
            .strokeBorder(colorScheme == .dark ? .white : .black, lineWidth: 3)
            .frame(width: 30, height: 30)
            .onTapGesture {
                withAnimation {
                    showColorPicker.toggle()
                }
            }
    }
}


