//
//  CategoryDetailSession.swift
//  Project Pegasus
//
//  Created by Lorenzo Vecchio on 29/02/24.
//

import SwiftUI

struct CategoryDetailSession: View {
    private var name: String
    private var color: Color
    private var progress: Double
    private var gradient: LinearGradient?
    
    init(name: String, color: Color , progress: Double, gradient: LinearGradient? = nil) {
        self.name = name
        self.color = color
        self.progress = progress
        self.gradient = gradient
    }
    
    var body: some View {
        HStack {
            Text(name.capitalized)
                .padding()
                //.background(gradient)
                .foregroundColor(.white)
                .cornerRadius(200)
                .frame(height: 40)
                .font(Font.custom("Helvetica Neue", size: 18).weight(.regular))
            Spacer()
            Text("\(Int(progress * 100))%")
                .foregroundColor(.white)
            
            CircularProgressView(progress: progress, color: .white)
                .frame(width: 20)
                .padding(.trailing)
        }
        .background(gradient != nil ? AnyView(gradient!) : AnyView(Color(color)))
        .cornerRadius(200)
        .frame(height: 40)
    }
}
