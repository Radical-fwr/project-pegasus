//
//  Streak.swift
//  Project Pegasus
//
//  Created by Lorenzo Vecchio on 28/02/24.
//

import SwiftUI
import SwiftData

struct Streak: View {
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
                Image("arrow-up-large")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(.white)
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
                            }
                        } completion: {
                            withAnimation(.easeInOut) {
                                if (opened) {
                                    textVisible = true
                                }
                            }
                        }
                    }
                
                if (textVisible) {
                    Text("STREAK")
                    .font(Font.custom("Montserrat", size: 36).weight(.bold))
                    .foregroundColor(.white)
                }
                
                ScrollView{
                    ForEach(sessions) { session in
                        SessionWStats(session: session)
                    }
                }.padding()
            }
            .frame(width: UIScreen.main.bounds.width)
            .background(
                LinearGradient(gradient: Gradient(colors: [opened ? .black : .clear, opened ? .white : .black.opacity(0.5)]), startPoint: .top, endPoint: .bottom)
            )
            .padding(.top, position)
            
            //.position(x: position)
            
        }
        
    }
}

#Preview {
    ZStack{
        Color.black.ignoresSafeArea()
        Text("ciao")
        Streak()
    }
}
