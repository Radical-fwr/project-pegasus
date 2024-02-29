//
//  TopBar.swift
//  Project Pegasus
//
//  Created by Lorenzo Vecchio on 05/12/23.
//

import SwiftUI

struct TopBar: View {
    @Environment(\.colorScheme) var colorScheme
    @Binding var navToSettings: Bool
    @Binding var navToProfile: Bool
    
    var body: some View {
        HStack {
            // top bar
            NavigationLink(destination: Settings(), isActive: $navToSettings) {
                Image("menu")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(colorScheme == .dark ? .white : .black)
                    .frame(width: 30)
                    .padding()
            }
            
            Spacer()
            
            Text("r.")
                .font(Font.custom("HelveticaNeue", size: 40))
                .fontWeight(.bold)
                .foregroundColor(colorScheme == .dark ? .white : .black)
            
            Spacer()
            
            NavigationLink(destination: Profile(), isActive: $navToProfile) {
                Image(systemName: "person")
                    .font(.system(size: 30))
                    .padding()
                    .foregroundColor(colorScheme == .dark ? .white : .black)
            }
        }
        .padding(.horizontal, 30)
        .padding(.top, 20)
    }
}
