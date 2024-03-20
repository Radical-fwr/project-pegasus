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
    var lightColor = "BFB48F"
    
    var body: some View {
        VStack {
            ZStack {
                Rectangle()
                    .foregroundColor(.clear)
                    .frame(height: 120)
                    .background(
                        RadialGradient(gradient: Gradient(colors: colorScheme == .dark ? [.black, .white.opacity(0.4)] : [Color(hex: lightColor), .white.opacity(0.4)]), center: .center, startRadius: 250, endRadius: 2)
                    )
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .inset(by: 0.5)
                            .stroke(colorScheme == .dark ? .gray : .white, lineWidth: 1)
                    )
                
                Text("Scopri la sessione ideale \nbasata sulle tue performance:")
                    .foregroundColor(colorScheme == .dark ? .white : .black)
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
