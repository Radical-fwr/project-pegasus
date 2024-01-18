//
//  RunningTimer.swift
//  Project Pegasus
//
//  Created by Lorenzo Vecchio on 14/12/23.
//

import SwiftUI
import SwiftData

struct RunningTimer: View {
    @Environment(\.modelContext) private var context
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @StateObject var timerManager = TimerManager()
    @State private var degrees: Double = 0
    @Query var sessions: [Session]
    @State private var mainColor: Color = .white
    
    func changeMainColor(_ color: Color) {
        self.mainColor = color
    }
    
    var body: some View {
        NavigationStack {
            ZStack{
                Color.black.ignoresSafeArea()
                VStack{
                    Spacer()
                    Rectangle()
                        .fill(LinearGradient(gradient: Gradient(colors: [mainColor, mainColor.opacity(0.4), Color.clear]), startPoint: .bottom, endPoint: .top))
                        .frame(width: UIScreen.main.bounds.width, height: 150)
                        .foregroundColor(Color.blue)
                        .ignoresSafeArea()
                }.ignoresSafeArea()
                ZStack {
                    FadingCircleView(size: UIScreen.main.bounds.width * 0.7, color: mainColor)
                        //.animation(nil)
                    CircleMovingLine(color: mainColor, lineLenght: 150, speed: 6, size: 100)
                    CircleMovingLine(color: mainColor, lineLenght: 150, speed: 5, size: 80, wait: 1)
                    CircleMovingLine(color: mainColor, lineLenght: 150, speed: 10, size: 120, wait: 2)
                        .rotationEffect(.degrees(70))
                    CircleMovingLine(color: mainColor, lineLenght: 150, speed: 4, size: 80, wait: 3)
                        .rotationEffect(Angle(degrees: 200))
                    CircleMovingLine(color: mainColor, lineLenght: 150, speed: 4, size: 110, wait: 4)
                        .rotationEffect(Angle(degrees: 270))
                    
//                    ZStack {
//                        FadingCircleView(size: 270, color: mainColor)
//                            //.animation(nil)
//                        CircleMovingLine(color: mainColor, lineLenght: 150, speed: 6, size: 100)
//                        CircleMovingLine(color: mainColor, lineLenght: 150, speed: 5, size: 80)
//                        CircleMovingLine(color: mainColor, lineLenght: 150, speed: 10, size: 120)
//                            .rotationEffect(.degrees(70))
//                        CircleMovingLine(color: mainColor, lineLenght: 150, speed: 4, size: 80)
//                            .rotationEffect(Angle(degrees: 200))
//                        CircleMovingLine(color: mainColor, lineLenght: 150, speed: 4, size: 110)
//                            .rotationEffect(Angle(degrees: 270))
//                    }
//                    .rotationEffect(.degrees(90))
                }
                .rotationEffect(.degrees(degrees))
                .onAppear {
                    withAnimation(.linear(duration: 30).repeatForever(autoreverses: false)) {
                        degrees = 360
                    }
                }
            }
        }
        .onAppear() {
            self.timerManager.startUpdatingRemainingTime()
            timerManager.getFirstPendingTimerIdentifier { identifier in
                if let identifier = identifier {
                    if let session = sessions.first(where: { $0.id == identifier }) {
                        changeMainColor(Color(hex: session.category!.color))
                    }
                }
            }
        }
        .navigationBarTitle("")
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
        .onChange(of: timerManager.remainingTime) {
            if timerManager.remainingTime == 0 {
                if let identifier = timerManager.identifier {
                    if let session = sessions.first(where: { $0.id == identifier }) {
                        session.stopDate = session.startDate.addingTimeInterval(session.timeGoal)
                        do {
                            try context.save()
                        } catch {
                            print("Error saving context: \(error)")
                        }
                    } else {
                        print("errore nell'aggiornare la sessione")
                    }
                }
                self.presentationMode.wrappedValue.dismiss()
            }
        }
    }
}



#Preview {
    RunningTimer()
}

// Users/lorenzovecchio/Library/Developer/Xcode/DerivedData/Project_Pegasus-fvvjapjltlafqwfhxdjvzpptfywj/
// Build/Products/Debug-iphoneos/PackageFrameworks/SwiftUIIntrospect-Dynamic.framework/SwiftUIIntrospect-Dynamic
