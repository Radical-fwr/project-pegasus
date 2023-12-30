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
    @State private var heartPulse: CGFloat = 1
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
                        .frame(width: UIScreen.main.bounds.width, height: 100)
                        .foregroundColor(Color.blue)
                        .ignoresSafeArea()
                }.ignoresSafeArea()
                VStack{
                    Spacer()
                    Text("\(timerManager.remainingTime)")
                }
                FadingCircleView(size: 250, color: mainColor)
                    .scaleEffect(heartPulse)
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
            withAnimation(.easeInOut(duration:3).repeatForever(autoreverses: true)) {
                heartPulse = 1.25 * heartPulse
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

struct FadingCircleView: View {
    var size: Double = 150
    var color: Color = .white
    
    var body: some View {
        Circle()
            .fill(
                RadialGradient(
                    gradient: Gradient(colors: [color, Color.clear]),
                    center: .center,
                    startRadius: 0,
                    endRadius: size/2
                )
            )
            .frame(width: size, height: size)
        Circle()
            .fill(
                RadialGradient(
                    gradient: Gradient(colors: [color, Color.clear]),
                    center: .center,
                    startRadius: 0,
                    endRadius: size/2
                )
            )
            .frame(width: size, height: size)
        Circle()
            .fill(
                RadialGradient(
                    gradient: Gradient(colors: [color, Color.clear]),
                    center: .center,
                    startRadius: 0,
                    endRadius: size/2
                )
            )
            .frame(width: size, height: size)
    }
}

#Preview {
    RunningTimer()
}
