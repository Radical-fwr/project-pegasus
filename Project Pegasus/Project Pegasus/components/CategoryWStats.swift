//
//  CategoryWStats.swift
//  Project Pegasus
//
//  Created by Lorenzo Vecchio on 16/11/23.
//

import SwiftUI

struct CategoryWStats: View {
    private var name: String
    private var color: Color
    private var progress: Double
    
    init(name: String, color: Color, progress: Double) {
        self.name = name
        self.color = color
        self.progress = progress
    }
    
    var body: some View {
        HStack {
            Text(name)
                .padding()
                .background(Color(color))
                .foregroundColor(.white)
                .cornerRadius(200)
                .frame(height: 40)
            Spacer()
            Text("\(Int(progress * 100))%")
            CircularProgressView(progress: progress, color: .white)
                .frame(width: 20)
                .padding(.trailing)
        }
        .background(Color(color))
        .cornerRadius(200)
        .frame(height: 40)
    }
}
