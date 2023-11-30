//
//  CircularProgressBar.swift
//  Project Pegasus
//
//  Created by Lorenzo Vecchio on 28/11/23.
//

import SwiftUI


struct CircularProgressView: View {
    var progress: Double = 0
    var color: Color = .white
    
    var body: some View {
        ZStack {
            //Circle()
            //    .stroke(
            //        Color.pink.opacity(0.5),
            //        lineWidth: 30
            //   )
            Circle()
                .trim(from: 0, to: progress)
                .stroke(
                    color,
                    // 1
                    style: StrokeStyle(
                        lineWidth: 3,
                        lineCap: .round
                    )
                )
                .rotationEffect(.degrees(-90))
        }
    }
}

#Preview {
    CircularProgressView(progress: 0.8, color: .black)
}
