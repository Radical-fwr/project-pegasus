//
//  ExpandableAiAnalysisRectangle.swift
//  Project Pegasus
//
//  Created by Giovanni Ercolano on 15/03/24.
//

import SwiftUI

struct ExpandableAiAnalysisRectangle: View {
    @Environment(\.colorScheme) var colorScheme
    @State private var isExpanded = false
    
    var body: some View {
        VStack {
            ZStack {
                Rectangle()
                    .foregroundColor(.clear)
                    .frame(height: 120)
                    .background(
                        colorScheme == .dark ? AnyView(
                            RadialGradient(gradient: Gradient(colors: [.black, .white.opacity(0.4)]), center: .center, startRadius: 250, endRadius: 2)
                        ) : AnyView(
                            LinearGradient(
                            stops: [
                                Gradient.Stop(color: Color(red: 0.75, green: 0.71, blue: 0.56).opacity(0.7), location: 0.00),
                                Gradient.Stop(color: Color(red: 0.75, green: 0.71, blue: 0.56).opacity(0.3), location: 1.00),
                            ],
                            startPoint: UnitPoint(x: 0, y: 0.5),
                            endPoint: UnitPoint(x: 1, y: 0.5)
                            )
                        )
                    )
                    .cornerRadius(10)
                    .shadow(color: colorScheme == .dark ? Color(red: 0.37, green: 0.37, blue: 0.37) : Color.white, radius: 0, x: 0, y: colorScheme == .dark ? 4 : 0)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .inset(by: 0.5)
                            .stroke(colorScheme == .dark ? .gray : .white, lineWidth: 1)
                    )
                
                Text("Scopri la sessione ideale \nbasata sulle tue performance:")
                    .foregroundColor(colorScheme == .dark ? .white : .white)
                    .font(.callout)
                    .multilineTextAlignment(.center)
            }
        }
        .padding(.horizontal)
    }
}

#Preview {
    return Profile()
}
