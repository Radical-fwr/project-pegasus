//
//  SessionWStats.swift
//  Project Pegasus
//
//  Created by Lorenzo Vecchio on 28/02/24.
//

import SwiftUI

struct SessionWStats: View {
    @Environment(\.colorScheme) var colorScheme
    var session: Session
    
    var body: some View {
        HStack {
            Text(session.subCategory != nil ? session.subCategory!.name : "Nessuna")
                .foregroundColor(colorScheme == .dark ? .white : .black)
                .padding()
                .cornerRadius(200)
                .frame(height: 40)
                .font(Font.custom("HelveticaNeue", size: 18).weight(.light))
            
            Spacer()
            Spacer()
            Spacer()
            
            HStack{
                Text(session.category!.name.uppercased())
                    .foregroundColor(Color(hex: session.category!.color))
                    .padding()
                    .cornerRadius(200)
                    .frame(height: 40)
                    .font(Font.custom("HelveticaNeue", size: 18).weight(.light))
                Spacer()
            }.frame(width: UIScreen.main.bounds.width * 0.3)
            Spacer()
            
            CircularProgressView(progress: session.progress, color: colorScheme == .dark ? .white : .black)
                .frame(width: 20)
                .padding(.trailing)
        }
        .background(LinearGradient(gradient: Gradient(colors: [
            colorScheme == .dark ? Color(hex: "343339") : Color(hex: "D2C8B3"),
            colorScheme == .dark ? Color(hex: "343339").opacity(0.7) : Color(hex: "D2C8B3").opacity(0.7)
        ]),startPoint: .leading, endPoint: .trailing))
        .cornerRadius(200)
        .frame(height: 40)
    }
}
