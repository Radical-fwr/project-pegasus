//
//  EndOFSession.swift
//  Project Pegasus
//
//  Created by Lorenzo Vecchio on 28/02/24.
//

import SwiftUI
import SwiftData

struct EndOFSession: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.modelContext) private var context
    var session: Session?
    @State var rating: Int = 1
    
    var body: some View {
        let duration = session!.stopDate!.timeIntervalSince(session!.startDate)
        NavigationStack{
            ZStack{
                
                colorScheme == .dark ? Color.black.edgesIgnoringSafeArea(.all) : Color(hex: "F2EFE9").edgesIgnoringSafeArea(.all)
                
                VStack{
                    HStack{
                        Spacer()
                        Button {
                            session!.rating = rating
                            do {
                                try context.save()
                                print("rating saved")
                            } catch {
                                print("Error saving context: \(error)")
                            }
                            NotificationCenter.default.post(name: NSNotification.Name("goHome"), object: nil)
                        } label: {
                            Image(systemName: "xmark")
                                .resizable()
                                .renderingMode(.template).foregroundColor(colorScheme == .dark ? Color(hex: "F2EFE9") : .black)
                                .frame(width: 25,height: 25)
                                
                        }
                        
                    }
                    .padding(.horizontal)
                    Spacer()
                    
                    Text("ANALISI ROUND")
                        .font(Font.custom("Montserrat", size: 36).weight(.bold))
                    
                    Spacer()
                    Text("Macroeconomia")
                        .font(Font.custom("Montserrat", size: 24).weight(.bold))
                        .foregroundStyle(LinearGradient(colors: [Color.init(uiColor: .label), Color.init(hex: session?.category?.color ?? "#FFFFFF")], startPoint: .top, endPoint: .bottom))
                    Spacer()
                    if session?.isCompleted ?? false{
                        ActivityProgressView(progress: 1, color: Color.init(hex: session?.category?.color ?? "#FFFFFF"))
                        Spacer()
                    }
                    
                    
                    HStack{
                        Text("Attività finita in:")
                            .font(Font.custom("Helvetica Neue", size: 20))
                        Spacer()
                        Text("\(Int(duration) / 3600)h \(Int(duration) % 3600 / 60)m")
                            .font(Font.custom("Helvetica Neue", size: 24).weight(.bold))
                    }.padding(.horizontal)
                    
                    Spacer()
                    HStack{
                        Text("Hai usato il telefono:")
                            .font(Font.custom("Helvetica Neue", size: 20))
                        Spacer()
                        Text("\(Int(session!.timeGoal) / 3600)h \(Int(session!.timeGoal) % 3600 / 60)m")
                            .font(Font.custom("Helvetica Neue", size: 24).weight(.bold))
                    }.padding(.horizontal)
                    Spacer()
                    
                    HStack{
                        Text("Periodo maggiore di \ninutilizzo del telefono:")
                            .font(Font.custom("Helvetica Neue", size: 20))
                        Spacer()
                        Text("\(Int(session!.timeGoal) / 3600)h \(Int(session!.timeGoal) % 3600 / 60)m")
                            .font(Font.custom("Helvetica Neue", size: 24).weight(.bold))
                    }.padding(.horizontal)
                    
                    
                    Spacer()
                    if !(session?.isCompleted ?? true){
                        ActivityProgressView(progress: session?.progress ?? 0, color: Color.init(hex: session?.category?.color ?? "#FFFFFF"))
                        Spacer()
                    }
                    Text("Valuta la tua sessione:")
                        .font(Font.custom("Helvetica Neue", size: 20))
                    Spacer()
                    RatingSelector(rating: $rating, borderColor: Color(hex: session!.category!.color))
                    
                    Spacer()
                    
                    //                    Text(session!.category!.name.uppercased())
                    //                        .font(Font.custom("Helvetica Neue", size: 36).weight(.bold))
                    //                    .multilineTextAlignment(.center)
                    //                    
                    //                    
                    //                    Spacer()
                    //                    
                    //                    Button(action: {
                    //                        session!.rating = rating
                    //                        do {
                    //                            try context.save()
                    //                            print("rating saved")
                    //                        } catch {
                    //                            print("Error saving context: \(error)")
                    //                        }
                    //                        goHome = true
                    //                    }) {
                    //                        Image("home")
                    //                            .resizable()
                    //                            .aspectRatio(contentMode: .fit)
                    //                            .padding(25)
                    //                            .foregroundColor(colorScheme == .dark ? .black : .white)
                    //                            
                    //                    }
                    //                    .background(colorScheme == .dark ? .white : .black)
                    //                    .frame(width: 80)
                    //                    .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                    
                    // Spacer()
                }
                .padding(.horizontal)
            }
        }
        .navigationBarTitle("")
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
    }
}
