//
//  DarkLightModeSelector.swift
//  Project Pegasus
//
//  Created by Lorenzo Vecchio on 21/04/24.
//

import SwiftUI

struct DarkLightModeSelector: View {
    @Environment(\.colorScheme) var colorScheme
    @AppStorage("displayMode") var displayMode: String = "system"
    
    @State var selectedItem: Int = 1
    @State var circleOffsetHorizontal = 0.0
    
    var body: some View {
        ZStack{
            HStack{
                if displayMode == "system" || displayMode == "light" {
                    Spacer()
                }
                ZStack {
                    Circle()
                        .stroke(colorScheme == .dark ? Color.white.opacity(0.5) : Color.black.opacity(0.5), lineWidth: 2) // Add border to circle
                        .frame(width: 30, height: 30) // Set circle size
                    Circle()
                        .fill(Color.clear) // Make circle empty inside
                        .frame(width: 20, height: 20) // Set empty circle size
                    Circle()
                        .fill(Color.clear) // Transparent overlay to capture touch events
                        .contentShape(Circle()) // Set the shape to capture events
                        .frame(width: 30, height: 30) // Set the size to match the outer circle
                }
                    .padding(EdgeInsets(top: 5, leading: 9, bottom: 5, trailing: 9))
                    .offset(x: circleOffsetHorizontal)
//                    .gesture(
//                        DragGesture()
//                            .onChanged { value in
//                                circleOffsetHorizontal = value.translation.width
//                            }
//                            .onEnded { value in
//                                circleOffsetHorizontal = 0
//                            }
//                    )
                if displayMode == "system" || displayMode == "dark" {
                    Spacer()
                }
            }
            HStack{
                // Moon icon
                Image("moon")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundStyle(colorScheme == .dark ? Color.white : Color.black)
                    .frame(width: 15)
                    .padding()
                    .onTapGesture {
                        displayMode = "dark"
                    }
                
                GradientLine()
                
                // Text
                Text("A")
                    .font(Font.custom("Montserrat", size: 24))
                    .fontWeight(.bold)
                    .onTapGesture {
                        displayMode = "system"
                    }
                
                GradientLine().rotationEffect(Angle(degrees: 180))
                
                // Sun icon
                Image("sun")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(colorScheme == .dark ? .white : .black)
                    .frame(width: 15)
                    .padding()
                    .onTapGesture {
                        displayMode = "light"
                    }
            }
        }
        .padding()
        
    }
}




struct GradientLine: View {
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        GeometryReader { geometry in
            Path { path in
                let startPoint = CGPoint(x: 0, y: geometry.size.height * 0.5)
                let endPoint = CGPoint(x: geometry.size.width, y: geometry.size.height * 0.5)
                
                path.move(to: startPoint)
                path.addLine(to: endPoint)
            }
            .stroke(
                LinearGradient(
                    gradient: Gradient(colors: [
                        colorScheme == .dark ? .white : .black,
                        .clear
                    ]),
                    startPoint: .leading,
                    endPoint: .trailing
                ),
                style: StrokeStyle(lineWidth: 2, lineCap: .round)
            )
        }
        .frame(height: 50) // Adjust the height as needed
    }
}
