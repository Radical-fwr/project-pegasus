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
    @Query var categories: [Category]
    @State private var isSheetPresented: Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack{
                Color.black.edgesIgnoringSafeArea(.all)
                
                VStack {
                    if let user = users.first {
                        let fallback =
                        Text(user.nome.prefix(2).description.uppercased())
                            .font(Font.custom("HelveticaNeue", size: 50))
                            .foregroundColor(Color.black)
                            .frame(width: 120, height: 120)
                            .background(Color.white)
                            .clipShape(Circle())
                        if let imageData = user.imageData {
                            if let uiImage = UIImage(data: imageData) {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 120, height: 120)
                                    .clipShape(Circle())
                                    .overlay(Circle().stroke(Color.white, lineWidth: 1))
                                    .padding()
                            } else {
                                fallback
                            }
                        } else {
                            fallback
                        }
                        Text(user.nome)
                            .font(Font.custom("HelveticaNeue", size: 30))
                            .fontWeight(.bold)
                            .padding()
                        ScrollView{
                            ForEach(categories) { category in
                                CategoryWStats(
                                    name: category.name.uppercased(),
                                    color: Color(hex: category.color),
                                    progress: category.progress
                                )
                                .frame(maxWidth: UIScreen.main.bounds.size.width*0.75)
                                .padding(5)
                            }
                        }
                        Spacer()
                        Text("+ Nuovo Tag")
                            .font(Font.custom("", size: 30))
                            .padding()
                            .onTapGesture {
                                isSheetPresented = true
                            }
                    } else {
                        Text("US")
                            .font(Font.custom("HelveticaNeue", size: 50))
                            .foregroundColor(Color.black)
                            .frame(width: 120, height: 120)
                            .background(Color.white)
                            .clipShape(Circle())
                        Text("Error")
                            .font(Font.custom("HelveticaNeue", size: 30))
                            .fontWeight(.bold)
                            .padding()
                        CategoryWStats(name: "Test", color: .blue, progress: 0.70)
                            .frame(maxWidth: UIScreen.main.bounds.size.width*0.75)
                        Spacer()
                        Text("+ Nuovo Tag")
                            .font(Font.custom("", size: 30))
                            .padding()
                            .onTapGesture {
                                isSheetPresented = true
                            }
                    }
                }
            }
        }
        .background(.black)
        .foregroundColor(.white)
        .sheet(isPresented: $isSheetPresented, onDismiss: {isSheetPresented = false}, content: {
            AddCategory(isPresented: $isSheetPresented).background(.black)
        })
    }
}

#Preview {
    Profile()
}
