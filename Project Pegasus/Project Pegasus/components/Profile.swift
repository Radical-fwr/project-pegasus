//
//  Profile.swift
//  Project Pegasus
//
//  Created by Lorenzo Vecchio on 14/11/23.
//

import SwiftUI
import SwiftData

struct Profile: View {
    @Environment(\.modelContext) private var context
    @Query var users: [User]
    
    var body: some View {
        ZStack{
            Color.black.edgesIgnoringSafeArea(.all)
            VStack{
                if let user = users.first {
                    Text("User")
                    Text(user.nome)
                } else {
                    Text("User not loaded")
                }
            }
        }
        .background(.black)
        .foregroundColor(.white)
    }
}

#Preview {
    Profile()
}
