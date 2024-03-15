//
//  CategoryWStats.swift
//  Project Pegasus
//
//  Created by Lorenzo Vecchio on 16/11/23.
//

import SwiftUI

struct CategoryWStats: View {
    @Environment(\.colorScheme) var colorScheme
    private var name: String
    private var color: Color
    private var progress: Double
    private var gradient: LinearGradient?
    private var useColorScheme: Bool
    
    init(name: String, color: Color , progress: Double, gradient: LinearGradient? = nil, useColorScheme: Bool) {
        self.name = name
        self.color = color
        self.progress = progress
        self.gradient = gradient
        self.useColorScheme = useColorScheme
    }
    
    var body: some View {
        HStack {
            Text(name.capitalized)
                .padding()
                .foregroundColor(useColorScheme == true ? colorScheme == .dark ? .white : .black : color)
                .cornerRadius(200)
                .frame(height: useColorScheme == true ? 40 : 50)
                .font(Font.custom("Helvetica Neue", size: 24).weight(.semibold))
            
            Spacer()
            
            CircularProgressView(progress: progress, color: useColorScheme == true ? colorScheme == .dark ? .white : .black : color)
                .frame(width: 20)
                .padding(.trailing)
        }
        .background(gradient != nil ? AnyView(gradient!) : AnyView(Color(color)))
        .cornerRadius(200)
        .frame(height: useColorScheme == true ? 40 : 53)
    }
}


#Preview {
    return Profile()
}
