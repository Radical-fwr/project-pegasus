//
//  categoryBox.swift
//  Project Pegasus
//
//  Created by Giovanni Ercolano on 22/04/24.
//

import SwiftUI
import SwiftData

struct CategoryBox: View {
    @Environment(\.colorScheme) var colorScheme
    @Query var categories: [Category] = []
    @State private var selectedItem = 0
    @State private var isEditing = false
    @State private var editedCategoryName = ""
    
    var body: some View {
        ZStack{
            VStack{
                HStack{
                    Text("Categorie".uppercased())
                        .font(Font.custom("Montserrat", size: 32).weight(.bold))
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity,alignment: .leading)
                        .foregroundColor(colorScheme == .dark ? .white : .black)
                    Spacer()
                    Button(action: {
                        // Toggle tra espanso e collassato per questa sezione
                        
                    }) {
                        Image(colorScheme == .dark ? "lightCategory" : "darkCategory")
                            .resizable()
                            .frame(width: 32, height: 32)
                    }
                }
                
                TabView(selection: $selectedItem) {
                    ForEach(categories.indices, id: \.self) { index in
                        let category = categories[index]
                        HStack(alignment: .center) {
                            Spacer()
                            if index == selectedItem && isEditing {
                                TextField("Nuovo nome", text: $editedCategoryName, onCommit: {
                                    // Salvare le modifiche al nome della categoria
                                    if !editedCategoryName.isEmpty {
                                        categories[index].name = editedCategoryName
                                        // Aggiungi qui il codice per salvare le modifiche nel tuo sistema di gestione dati
                                        isEditing.toggle()
                                    }
                                })
                                .font(Font.custom("Montserrat", size: 24).weight(.bold))
                                .foregroundColor(Color(hex: colorScheme == .dark ? category.color : category.darkColor))
                                .padding(.leading,10)
                                .padding(.trailing,15)
                            } else {
                                Text(category.name.uppercased())
                                    .font(
                                        Font.custom("Montserrat", size: 24)
                                            .weight(.bold)
                                    )
                                    .foregroundColor(Color(hex: colorScheme == .dark ? category.color : category.darkColor)).padding(.leading,10)
                            }
                            
                            Spacer(minLength: 10)
                            
                            Button(action: {
                                // Attiva la modalità di modifica quando il pulsante viene premuto
                                selectedItem = index
                                isEditing.toggle()
                                if !isEditing {
                                    // Salva le modifiche al nome della categoria
                                    if !editedCategoryName.isEmpty {
                                        categories[index].name = editedCategoryName
                                        // Aggiungi qui il codice per salvare le modifiche nel tuo sistema di gestione dati
                                    }
                                }
                            }){
                                Image(colorScheme == .dark ? "lightWrite" : "darkWrite")
                                    .resizable()
                                    .frame(width: 18, height: 18)
                                    .padding(.trailing,15)
                            }
                        }
                        .padding(.horizontal,20)
                        .padding(.bottom,25)
                        .tag(index)
                    }
                }
                .tabViewStyle(.page)
                .accentColor(colorScheme == .dark ? .white : .black)
                .frame(height:80)
                .background(LinearGradient(colors: colorScheme == .dark ? [Color(hex: categories[selectedItem].color).opacity(0.09), Color(hex: categories[selectedItem].color).opacity(0.6)] : [Color(hex: categories[selectedItem].darkColor).opacity(0.09), Color(hex: categories[selectedItem].darkColor).opacity(0.6)], startPoint: .leading, endPoint: .trailing).cornerRadius(10))
                
                
            }
        }
    }
}


