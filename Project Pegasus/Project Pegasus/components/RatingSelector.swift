//
//  RatingSelector.swift
//  Project Pegasus
//
//  Created by Lorenzo Vecchio on 28/02/24.
//

import SwiftUI

struct RatingSelector: View {
    @Binding var rating: Int
    let borderColor: Color
    
    var body: some View {
        HStack {
            ForEach(1..<6) { index in
                Circle()
                    .strokeBorder(borderColor, lineWidth: 2)
                    .background(index <= self.rating ? self.borderColor : Color.clear)
                    .frame(width: 30, height: 30)
                    .onTapGesture {
                        self.rating = index
                    }
                    .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
            }
        }
    }
}
