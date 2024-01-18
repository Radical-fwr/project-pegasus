//
//  CircleMovingLine.swift
//  Project Pegasus
//
//  Created by Lorenzo Vecchio on 12/01/24.
//

import SwiftUI

struct CircleMovingLine: View {
    var color: Color
    var lineLenght: Double
    var speed: TimeInterval
    var size: Double
    var wait: Double = 0
    @State private var position: Double = 0
    
    var body: some View {
        ZStack {
            FadingCircleView(size: size, color: color)
                .offset(x: position)
                .onAppear {
                    withAnimation(.easeInOut(duration: speed).repeatForever(autoreverses: true).delay(wait)) {
                        position = lineLenght
                    }
                }
        }
    }
}


#Preview {
    CircleMovingLine(
        color: .black,
        lineLenght: 50,
        speed: 1,
        size: 30
    )
}
