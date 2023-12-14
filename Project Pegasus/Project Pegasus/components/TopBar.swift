//
//  TopBar.swift
//  Project Pegasus
//
//  Created by Lorenzo Vecchio on 05/12/23.
//

import SwiftUI

struct TopBar: View {
    var body: some View {
        HStack {
            // top bar
            Image(systemName: "lock.circle.dotted")
                .font(.system(size: 30))
                .padding()
            
            Spacer()
            
            Text("r.")
                .font(Font.custom("HelveticaNeue", size: 40))
                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
            
            Spacer()
            
            NavigationLink(destination: Profile()) {
                Image(systemName: "person")
                    .font(.system(size: 30))
                    .padding()
            }
        }
    }
}

#Preview {
    ZStack {
        Color.black.edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
        TopBar().foregroundColor(.white)
    }
}
