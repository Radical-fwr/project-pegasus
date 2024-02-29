//
//  DelimitationBars.swift
//  Project Pegasus
//
//  Created by Lorenzo Vecchio on 12/01/24.
//

import SwiftUI

struct DelimitationBars: View {
    var body: some View {
        VStack{
            SingleBar()
            Spacer()
            SingleBar()
            
        }
        .frame(width: UIScreen.main.bounds.width * 0.95, height: 53)
    }
}

struct SingleBar: View {
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ZStack{
            Rectangle()
                .frame(width: UIScreen.main.bounds.width * 0.94, height: 0.6)
                .foregroundColor(colorScheme == .dark ? .white : .black)
            HStack{
                Triangle()
                    .frame(width: 8, height: 6)
                    .rotationEffect(.degrees(90))
                    .foregroundColor(colorScheme == .dark ? .white.opacity(0.8) : .black.opacity(0.8))
                Spacer()
                Triangle()
                    .frame(width: 8, height: 6)
                    .rotationEffect(.degrees(270))
                    .foregroundColor(colorScheme == .dark ? .white.opacity(0.8) : .black.opacity(0.8))
            }
        }
    }
}

#Preview{
    DelimitationBars()
}
