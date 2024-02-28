//
//  EndOFSession.swift
//  Project Pegasus
//
//  Created by Lorenzo Vecchio on 28/02/24.
//

import SwiftUI
import SwiftData

struct EndOFSession: View {
    @Environment(\.modelContext) private var context
    var session: Session?
    @State var rating: Int = 1
    @State private var goHome: Bool = false
    
    var body: some View {
        NavigationStack{
            ZStack{
                
                NavigationLink(destination: Home(), isActive: $goHome) {
                    EmptyView()
                }
                .hidden()
                .navigationBarHidden(true)
                .navigationBarBackButtonHidden(true)
                .animation(nil)
                
                Color.black.edgesIgnoringSafeArea(.all)
                VStack{
                    Text("radical.")
                    .font(Font.custom("Helvetica Neue", size: 36).weight(.bold))
                    .foregroundColor(.white)
                    
                    Spacer()
                    
                    Text("COM’É ANDATA?")
                    .font(Font.custom("Montserrat", size: 36).weight(.bold))
                    .foregroundColor(.white)
                    
                    Text("Lascia una valutazione:")
                    .font(Font.custom("HelveticaNeue", size: 20).weight(.light))
                    .foregroundColor(.white)
                    
                    RatingSelector(rating: $rating, borderColor: Color(hex: session!.category!.color))
                    
                    Spacer()
                    
                    Text("\(Int(session!.timeGoal) / 3600)h \(Int(session!.timeGoal) % 3600 / 60)m")
                        .font(Font.custom("Helvetica Neue", size: 36).weight(.bold))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white)
                    
                    Text(session!.category!.name.uppercased())
                        .font(Font.custom("Helvetica Neue", size: 36).weight(.bold))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white)
                    
                    Spacer()
                    
                    Button(action: {
                        session!.rating = rating
                        do {
                            try context.save()
                            print("rating saved")
                        } catch {
                            print("Error saving context: \(error)")
                        }
                        goHome = true
                    }) {
                        Image("home")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .padding(25)
                            .foregroundColor(.black)
                            
                    }
                    .background(.white)
                    .frame(width: 80)
                    .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                    
                    Spacer()
                }
            }
        }
        .navigationBarTitle("")
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
    }
}
