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
        .frame(width: UIScreen.main.bounds.width - 20, height: 67)
    }
}

struct SingleBar: View {
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        HStack(alignment: .center, spacing:-1.5){
            Triangle()
                .frame(width: 8, height: 6)
                .rotationEffect(.degrees(90))
                .foregroundColor(colorScheme == .dark ? .white.opacity(0.5) : .black.opacity(0.5))
            Rectangle()
                .frame(height: 0.6)
                .foregroundColor(colorScheme == .dark ? .white : .black)
            Triangle()
                .frame(width: 8, height: 6)
                .rotationEffect(.degrees(270))
                .foregroundColor(colorScheme == .dark ? .white.opacity(0.5) : .black.opacity(0.5))
        }
        //        ZStack{
        //            Rectangle()
        //                .frame(width: UIScreen.main.bounds.width  - 56, height: 0.6)
        //                .foregroundColor(colorScheme == .dark ? .white : .black)
        //            HStack{
        //                Triangle()
        //                    .frame(width: 8, height: 6)
        //                    .rotationEffect(.degrees(90))
        //                    .foregroundColor(colorScheme == .dark ? .white.opacity(0.5) : .black.opacity(0.5))
        //                Spacer()
        //                Triangle()
        //                    .frame(width: 8, height: 6)
        //                    .rotationEffect(.degrees(270))
        //                    .foregroundColor(colorScheme == .dark ? .white.opacity(0.5) : .black.opacity(0.5))
        //            }
        //        }
    }
}

#Preview{
    DelimitationBars()
}
