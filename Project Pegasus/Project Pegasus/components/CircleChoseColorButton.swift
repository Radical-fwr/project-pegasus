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
    var lightCircleBackground = "E5E5E5"
    var darkCircleBackground = "2F2F2F"
    
    var body: some View {
        Circle()
            .fill(showColorPicker ? Color(hex: colorScheme == .dark ? darkCircleBackground : lightCircleBackground) : Color.clear)
            .frame(width: 30, height: 30)
            .overlay(
                Circle().stroke(colorScheme == .dark ? Color.black : Color.white, lineWidth: 3)
            )
            .onTapGesture {
                withAnimation {
                    showColorPicker.toggle()
                }
            }
    }
}


#Preview {
    AddNewCategory()
}
