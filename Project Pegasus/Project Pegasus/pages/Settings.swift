//
//  Settings.swift
//  Project Pegasus
//
//  Created by Lorenzo Vecchio on 29/02/24.
//

import SwiftUI
import FamilyControls

struct Settings: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State var selection = FamilyActivitySelection()
    @State var isPresented = false
    
    var body: some View {
        NavigationStack{
            ZStack {
                
                colorScheme == .dark ? Color.black.edgesIgnoringSafeArea(.all) : Color(hex: "F2EFE9").edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                
                VStack {
                    Spacer().frame(height: 10)
                    HStack {
                        Spacer()
                        R_button()
                            .foregroundColor(colorScheme == .dark ? .white : .black)
                            .onTapGesture {
                                self.presentationMode.wrappedValue.dismiss()
                            }
                        
                    }.padding(.trailing)
                    Spacer().frame(height: 30)
                    
                    
                    Text("APP BLOCCATE")
                        .font(Font.custom("Montserrat", size: 36).weight(.bold))
                        .foregroundColor(colorScheme == .dark ? .white : .black)
                    
                    Spacer()
                    Button("Present FamilyActivityPicker") { isPresented = true }
                           .familyActivityPicker(isPresented: $isPresented,
                                                 selection: $selection)
                           .onChange(of: selection) { newSelection in
                               let applications = selection.applications
                               let categories = selection.categories
                               let webDomains = selection.webDomains
                           }
                           .foregroundColor(colorScheme == .dark ? .white : .black)
                    
                    
                    Spacer()
                }
            }
            .navigationBarTitle("")
            .navigationBarBackButtonHidden(true)
            .navigationBarHidden(true)
        }
    }
}


#Preview {
    Settings()
}
