//
//  StudioButtonStyle.swift
//  Project Pegasus
//
//  Created by Lorenzo Vecchio on 28/10/23.
//

import SwiftUI

struct CategoryButtonStyle: ButtonStyle {
    var color: Color = .white
    private var radius: CGFloat = 50
    
    init(color: Color) {
        self.color = color
    }
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(width: 120, height: 30)
            .foregroundColor(.white)
            .background(color.opacity(0))
            .cornerRadius(radius)
            .padding(.all, 1)
            .overlay(
            RoundedRectangle(cornerRadius: radius)
                .stroke(color, lineWidth: 2)
            )
    }
}
