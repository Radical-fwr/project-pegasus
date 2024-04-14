//
//  ToDo.swift
//  Project Pegasus
//
//  Created by Hasan on 14/04/2024.
//

import SwiftUI
import SwiftData

struct ToDo: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.presentationMode) var presentationMode
    @State var isPresented = false
    @Query var categories: [Category] = []
    @Query var subCategories: [SubCategory]
    @State private var selectedItem = 0
    @State var addSubCategory = false
    @State var newSubCategory = ""
    @State var newDateString = ""
    var body: some View {
        NavigationStack{
            ZStack {
                colorScheme == .dark ? Color.black.edgesIgnoringSafeArea(.all) : Color(hex: "F2EFE9").edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                
                VStack {
                    Spacer().frame(height: 10)
                    HStack {
                        Button {
                            
                        } label: {
                            Image(.graph)
                                .resizable()
                                .renderingMode(.template)
                                .frame(width: 28.5, height: 19)
                                .foregroundColor(colorScheme == .dark ? .white : .black)
                        }
                        
                        Spacer()
                        R_button()
                            .foregroundColor(colorScheme == .dark ? .white : .black)
                            .onTapGesture {
                                self.presentationMode.wrappedValue.dismiss()
                            }
                        
                        
                        
                    }
                    Spacer().frame(height: 30)
                    HStack{
                        
                        Text("TO DO LIST")
                            .font(Font.custom("Montserrat", size: 36).weight(.bold))
                            .foregroundColor(colorScheme == .dark ? .white : .black)
                        Spacer()
                        
                        Button {
                            
                        } label: {
                            Image(.checkmark2)
                                .resizable()
                                .renderingMode(.template)
                                .frame(width: 24, height: 25)
                                .foregroundColor(colorScheme == .dark ? .white : .black)
                        }
                        
                    }
                    
                    TabView(selection: $selectedItem) {
                        ForEach(categories){ category in
                            VStack(alignment:.leading){
                                Text(category.name.uppercased())
                                    .font(Font.custom("Montserrat", size: 24).weight(.bold))
                                    .foregroundColor(Color(hex: category.color))
                                
                                VStack(alignment:.leading,spacing: 16){
                                    if addSubCategory{
                                        HStack{
                                            CircularProgressView(progress: 0.8, color: Color.init(hex: category.color))
                                                .frame(width:16.5,height:16.5)
                                            
                                            TextField(text: $newSubCategory, prompt: Text("Home sessione")) {
                                                
                                            }
                                            .font(Font.custom("Montserrat", size: 15))
                                            
                                            Spacer()
                                            
                                            TextField(text: $newDateString, prompt: Text("00/00")) {
                                                
                                            }
                                            .font(Font.custom("Montserrat", size: 15).weight(.bold))
                                            .frame(width:48)
                                           
                                        }
                                    }
                                    ForEach(subCategories.filter({$0.parentCategory == category})){subCategory in
                                        Text(subCategory.name)
                                    }
                                    HStack(spacing:12) {
                                        Button {
                                            addSubCategory = true
                                        } label: {
                                            HStack{
                                                ZStack(alignment:.center){
                                                    Circle()
                                                        .stroke(Color.white)
                                                        .frame(width: 22, height: 22)
                                                    Image(systemName: "plus")
                                                        .resizable()
                                                        .frame(width: 12, height: 12)
                                                        //.font(Font.custom("HelveticaNeue", size: 20))
                                                }
                                                
                                                Text("Attivitá")
                                            }
                                            .foregroundColor(.white)
                                        }
                                        Spacer()
                                        Button {
                                            
                                        } label: {
                                            Image(.bin)
                                                .resizable()
                                                .renderingMode(.template)
                                                .foregroundColor(Color(hex: category.color))
                                                .frame(width: 25, height: 25)
                                        }
                                        
                                        
                                        
                                    }
                                    .font(Font.custom("HelveticaNeue", size: 16))
                                    
                                    
                                }
                                
                                Spacer()
                                
                                
                            }
                            .padding()
                            .tag(categories.firstIndex(of: category) ?? 0)
                           
                        }
                    }
                    .tabViewStyle(.page)
                    .frame(height:240)
                    .background(LinearGradient(colors: [Color(hex: categories[selectedItem].color).opacity(0.1), Color(hex: categories[selectedItem].color).opacity(0.6)], startPoint: .leading, endPoint: .trailing).cornerRadius(10))
                    
                    .padding(.horizontal)
                    Spacer()
                }
                .padding(.horizontal)
                .navigationBarTitle("")
                .navigationBarBackButtonHidden(true)
                .navigationBarHidden(true)
            }
        }
    }
    
}
#Preview {
    ToDo()
}
