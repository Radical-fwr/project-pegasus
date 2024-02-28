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
    @State private var categoryName: String = ""
    @State private var stopped = false
    
    @GestureState private var isHoldingCircle = false
    @State private var timer: Timer?
    @State private var remainingTime: Double = 10
    @State private var progress: Double = 0
    
    @State private var activeSession: Session?
    @State private var isSessionFinished: Bool = false
    
    func changeCategoryName(_ categoryName: String) {
        self.categoryName = categoryName
    }
    
    func changeMainColor(_ color: Color) {
        self.mainColor = color
    }
    
    func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            remainingTime-=1
            progress = 10 - remainingTime
        }
    }

    func stopTimer() {
        timer?.invalidate()
        timer = nil
        remainingTime=10
        progress=0
    }
    
    var body: some View {
        NavigationStack {
            ZStack{
                
                NavigationLink(destination: EndOFSession(session: activeSession), isActive: $isSessionFinished) {
                    EmptyView()
                }
                .hidden()
                .navigationBarHidden(true)
                .navigationBarBackButtonHidden(true)
                .animation(nil)
                
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
                    ZStack {
                        CircleMovingLine(color: mainColor, lineLenght: 150, speed: 6, size: 100)
                        CircleMovingLine(color: mainColor, lineLenght: 150, speed: 5, size: 80, wait: 1)
                        CircleMovingLine(color: mainColor, lineLenght: 150, speed: 10, size: 120, wait: 2)
                            .rotationEffect(.degrees(70))
                        CircleMovingLine(color: mainColor, lineLenght: 150, speed: 4, size: 80, wait: 3)
                            .rotationEffect(Angle(degrees: 200))
                        CircleMovingLine(color: mainColor, lineLenght: 150, speed: 4, size: 110, wait: 4)
                            .rotationEffect(Angle(degrees: 270))
                    }
                    .opacity(isHoldingCircle ? 0 : 1)
                }
                .rotationEffect(.degrees(degrees))
                .onAppear {
                    withAnimation(.linear(duration: 30).repeatForever(autoreverses: false)) {
                        degrees = 360
                    }
                }
                .gesture(
                    LongPressGesture(minimumDuration: 10)
                        .updating($isHoldingCircle) { value, state, transaction in
                            state = value
                        }
                        .onEnded { finished in
                            stopped = true
                            if let identifier = timerManager.identifier {
                                if let session = sessions.first(where: { $0.id == identifier }) {
                                    activeSession = session
                                    session.stopDate = Date()
                                    print(Date())
                                    do {
                                        try context.save()
                                        timerManager.deleteFirstPendingTimer(completion: { _ in })
                                        isSessionFinished = true
                                    } catch {
                                        print("Error saving context: \(error)")
                                    }
                                } else {
                                    print("errore nell'aggiornare la sessione")
                                }
                            }
                        }
                )
                .onChange(of: isHoldingCircle) {
                    if isHoldingCircle {
                        startTimer()
                    } else {
                        stopTimer()
                    }
                }
                
                ZStack {
                    VStack{
                        Text(".radical")
                            .font(Font.custom("HelveticaNeue", size: 36))
                            .fontWeight(.bold)
                            .animation(nil)
                        
                        Spacer().animation(nil)
                        
                        Text("Hai già finito?")
                            .font(Font.custom("Montserrat", size: 36))
                            .fontWeight(.bold)
                            .textCase(.uppercase)
                            .animation(nil)
                        
                        Text("Solleva il dito per riprendere:")
                            .font(Font.custom("HelveticaNeue", size: 20))
                            .animation(nil)
                        
                        Spacer().animation(nil)
                        
                        LiquidCircle(width: UIScreen.main.bounds.width * 0.8, progress: $progress, color: mainColor)
                        
                        Spacer().animation(nil)
                        
                        Text("\(categoryName)")
                            .font(Font.custom("HelveticaNeue", size: 36))
                            .fontWeight(.bold)
                            .textCase(.uppercase)
                            .animation(nil)
                        
                        Spacer().animation(nil)
                        
                        Spacer().animation(nil)
                    }
                }
                .opacity(isHoldingCircle ? 1 : 0)
            }
        }
        .onAppear() {
            self.timerManager.startUpdatingRemainingTime()
            timerManager.getFirstPendingTimerIdentifier { identifier in
                if let identifier = identifier {
                    if let session = sessions.first(where: { $0.id == identifier }) {
                        changeMainColor(Color(hex: session.category!.color))
                        changeCategoryName(session.category!.name)
                    }
                }
            }
        }
        .navigationBarTitle("")
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
        .onChange(of: timerManager.remainingTime) {
            if(!stopped) {
                if timerManager.remainingTime == 0 {
                    if let identifier = timerManager.identifier {
                        if let session = sessions.first(where: { $0.id == identifier }) {
                            activeSession = session
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
                    isSessionFinished = true
                }

            }
        }
    }
}



#Preview {
    RunningTimer()
}

// Users/lorenzovecchio/Library/Developer/Xcode/DerivedData/Project_Pegasus-fvvjapjltlafqwfhxdjvzpptfywj/
// Build/Products/Debug-iphoneos/PackageFrameworks/SwiftUIIntrospect-Dynamic.framework/SwiftUIIntrospect-Dynamic
