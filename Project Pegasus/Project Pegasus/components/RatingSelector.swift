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
        HStack{
            ForEach(1..<6) { index in
                Circle()
                    .strokeBorder(borderColor, lineWidth: 2)
                    .background(index <= self.rating ? self.borderColor : Color.clear)
                    .frame(width: 30, height: 30)
                    .frame(maxWidth: .infinity)
                    .onTapGesture {
                        self.rating = index
                    }
                    .clipShape(Circle())
            }
        }.frame(width: UIScreen.main.bounds.width - 10)
    }
}
