//
//  ExpandableAiAnalysisRectangle.swift
//  Project Pegasus
//
//  Created by Giovanni Ercolano on 15/03/24.
//

import SwiftUI

struct ExpandableAiAnalysisRectangle: View {
    @State private var isExpanded = false
    
    var body: some View {
        VStack {
            ZStack {
                Rectangle()
                    .foregroundColor(.clear)
                    .frame(height: 120)
                    .background(
                        RadialGradient(gradient: Gradient(colors: [.black, .white.opacity(0.4)]), center: .center, startRadius: 250, endRadius: 2)
                    )
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .inset(by: 0.5)
                            .stroke(.white, lineWidth: 1)
                    )
                
                // Aggiungi il testo qui
                Text("Scopri la sessione ideale \nbasata sulle tue performance:")
                    .foregroundColor(.white) // Cambia il colore del testo se necessario
                    .font(.callout) // Personalizza il font se necessario
                    .multilineTextAlignment(.center)
            }
        }
        .padding(.horizontal)
    }
}

#Preview {
    return Profile()
}
