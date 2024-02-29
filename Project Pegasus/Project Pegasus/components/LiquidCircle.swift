//
//  LiquidCircle.swift
//  Project Pegasus
//
//  Created by Lorenzo Vecchio on 24/02/24.
//

import SwiftUI

struct LiquidCircle: View {
    var width: CGFloat = UIScreen.main.bounds.width * 0.8
    @State var offset: Double = 490
    var maxProgress: Double = 10
    @Binding var progress: Double
    var color: Color = .blue
    
    var body: some View {
        ZStack {
            WaveAnimation(color: color)
                .offset(y: offset)
                .clipped()
                .contentShape(Circle())
                .border(.red)
//            HStack{
//                Button("increase") {
//                    progress += 1
//                    print("\(progress)")
//                }
//                Button("decrease") {
//                    progress -= 1
//                    print("\(progress)")
//                }
//            }
        }
        .onChange(of: progress) {            
            withAnimation(.easeInOut(duration: 0.9)) {
                progress = min(progress, maxProgress)
                offset = calculateOffset()
            }
        }
        .frame(width: width, height: width)
        .background(.clear)
        .contentShape(Circle())
        .clipShape(Circle())
        .clipped()
        .blur(radius: 20)
        //.border(.red)

    }
    
    private func calculateOffset() -> CGFloat {
        let progressRatio: Double = min((maxProgress - progress) / maxProgress, 1.0)
        let offsetRange: Double = 490 - 100
        let targetOffset = 100 + progressRatio * offsetRange
        return CGFloat(targetOffset)
    }
}



