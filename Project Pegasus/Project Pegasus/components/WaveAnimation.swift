//
//  WaveAnimation.swift
//  Project Pegasus
//
//  Created by Lorenzo Vecchio on 24/02/24.
//

import SwiftUI

struct Wave: Shape {
    
    var waveHeight: CGFloat = 15
    var phase: Angle = Angle(degrees: 20)
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: 0, y: rect.maxY)) // Bottom Left
        
        for x in stride(from: 0, through: rect.width, by: 1) {
            let relativeX: CGFloat = x / 50 //wavelength
            let sine = CGFloat(sin(relativeX + CGFloat(phase.radians)))
            let y = waveHeight * sine //+ rect.midY
            path.addLine(to: CGPoint(x: x, y: y))
        }
        
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY)) // Top Right
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY)) // Bottom Right
        
        return path
    }
}

struct WaveAnimation: View {
    @State private var phase: Double = 1
    @State private var increasing = true
    @State private var rotation: Double = 15
    var waveHeight: Double = 20
    var color: Color = .blue
    
    let timer = Timer.publish(every: 0.005, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack {
            Wave(waveHeight: waveHeight, phase: Angle(degrees: phase))
                .fill(color)
                .frame(width: UIScreen.main.bounds.width * 2 ,height: 600)
                .padding()
        }
        .rotationEffect(Angle(degrees: rotation))
        .onReceive(timer) { _ in
            withAnimation {
                if increasing {
                    phase += 1
                    if phase >= 10000 {
                        increasing = false
                    }
                } else {
                    phase -= 1
                    if phase <= 1 {
                        increasing = true
                    }
                }
            }
        }
        .onAppear{
            withAnimation(.easeInOut(duration: 3).repeatForever(autoreverses: true)) {
                rotation = -15
            }
        }
    }
}

#Preview {
    WaveAnimation(color: .black)
}
