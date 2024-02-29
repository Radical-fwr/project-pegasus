//
//  Streak.swift
//  Project Pegasus
//
//  Created by Lorenzo Vecchio on 28/02/24.
//

import SwiftUI
import SwiftData

struct Streak: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.modelContext) private var context
    @Query var sessions: [Session]
    @State private var rotation: Double = 180
    @State var opened: Bool = false
    @State var textVisible: Bool = false
    @State var position: Double = UIScreen.main.bounds.height - 130
    
    var body: some View {
        ZStack {
            VStack{
                Spacer()
                Spacer()
                Spacer()
                Spacer()
                Spacer()
                
                if (textVisible) {
                    HStack{
                        Text("STREAK")
                        .font(Font.custom("Montserrat", size: 36).weight(.bold))
                        .foregroundColor(colorScheme == .dark ? .white : .black)
                        
                        Spacer()
                    }.padding()
                    
                }
                
                Image("arrow-up-large")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(colorScheme == .dark ? .white : .black)
                    .frame(width: 50)
                    .rotationEffect(Angle(degrees: rotation))
                    .onTapGesture {
                        withAnimation(.easeInOut) {
                            if (opened) {
                                position = UIScreen.main.bounds.height - 130
                                rotation = 180
                                opened = false
                                textVisible = false
                            } else {
                                position = 25
                                rotation = 0
                                opened = true
                                textVisible = true
                            }
                        }
//                        completion: {
//                            withAnimation(.easeInOut) {
//                                if (opened) {
//                                    textVisible = true
//                                }
//                            }
//                        }
                    }
                
                
                
                ScrollView{
                    ForEach(sessions) { session in
                        SessionWStats(session: session)
                    }
                    Rectangle()
                        .fill(Color.clear)
                        .frame(height: 100)
                        
                }
                .padding()
                .scrollIndicators(.hidden)
            }
            .frame(width: UIScreen.main.bounds.width)
            .background(
                LinearGradient(gradient: Gradient(colors: [
                    opened ?
                    colorScheme == .dark ? .black : Color(hex: "F2EFE9") :
                        .clear,
                    opened ?
                    colorScheme == .dark ? .white : Color(hex: "F2EFE9") :
                    colorScheme == .dark ? .black.opacity(0.5) : Color(hex: "F2EFE9").opacity(0.5)
                ]), startPoint: .top, endPoint: .bottom)
            )
            .padding(.top, position)
            
            //.position(x: position)
            
        }
        
        if (opened) {
            VStack{
                Spacer()
                Rectangle()
                    .fill(LinearGradient(gradient: Gradient(colors: [
                        .white,
                        .white.opacity(0.4),
                        .clear
                    ]), startPoint: .bottom, endPoint: .top))
                    .frame(width: UIScreen.main.bounds.width, height: 150)
                    //.foregroundColor(Color.blue)
                    .ignoresSafeArea()
            }.ignoresSafeArea()
        }
        if (!opened) {
            VStack{
                Spacer()
                Rectangle()
                    .fill(LinearGradient(gradient: Gradient(colors: [
                        colorScheme == .dark ? .black : Color(hex: "F2EFE9"),
                        colorScheme == .dark ? .black.opacity(0.4) : Color(hex: "F2EFE9").opacity(0.4),
                        .clear
                    ]), startPoint: .bottom, endPoint: .top))
                    .frame(width: UIScreen.main.bounds.width, height: 50)
                    //.foregroundColor(Color.blue)
                    .ignoresSafeArea()
            }.ignoresSafeArea()
        }
        
    }
}

#Preview {
    ZStack{
        Streak()
    }
}
