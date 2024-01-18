//
//  FadingCircleView.swift
//  Project Pegasus
//
//  Created by Lorenzo Vecchio on 12/01/24.
//

import SwiftUI

struct FadingCircleView: View {
    var size: Double = 150
    var color: Color = .white
    
    var body: some View {
        Circle()
            .fill(
                RadialGradient(
                    gradient: Gradient(colors: [color, Color.clear]),
                    center: .center,
                    startRadius: 0,
                    endRadius: size/2
                )
            )
            .frame(width: size, height: size)
        Circle()
            .fill(
                RadialGradient(
                    gradient: Gradient(colors: [color, Color.clear]),
                    center: .center,
                    startRadius: 0,
                    endRadius: size/2
                )
            )
            .frame(width: size, height: size)
        Circle()
            .fill(
                RadialGradient(
                    gradient: Gradient(colors: [color, Color.clear]),
                    center: .center,
                    startRadius: 0,
                    endRadius: size/2
                )
            )
            .frame(width: size, height: size)
    }
}
