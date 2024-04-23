//
//  RunningTimer.swift
//  Project Pegasus
//
//  Created by Lorenzo Vecchio on 14/12/23.
//

import SwiftUI
import SwiftData
import SwiftUIGIF
import AVKit

struct RunningTimer: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.modelContext) private var context
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @StateObject var timerManager = TimerManager()
    @StateObject var blockManager = BlockManager.shared
    @State private var degrees: Double = 0
    @Query var sessions: [Session]
    @State private var mainColor: Color = .white
    @State private var categoryName: String = ""
    @State private var stopped = false
    
    @State private var isHoldingCircle = false
    @State private var timer: Timer?
    @State private var remainingTime: Double = 10
    @State private var progress: Double = 0
    
    @State private var activeSession: Session?
    @State private var isSessionFinished: Bool = false
    @State private var gifName : String? = nil
    
    @State private var position: CGSize = .zero
    @State private var isDragging = false
    
    @State var player = AVPlayer()
    
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
        let longPressGesture = LongPressGesture(minimumDuration: 3)
        
            .onChanged { state in
                if state {
                    isHoldingCircle = state
                }
            }
            .onEnded { _ in
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    self.isHoldingCircle = false
                }
            }
//            .updating($isHoldingCircle) { value, state, transaction in
//                state = value
//            }
                 
        let dragGesture = DragGesture()
                   .onChanged { value in
                       isHoldingCircle = true
                       let height = value.translation.height > 200 ? 200 :  value.translation.height < -200 ? -200 : value.translation.height
                       position = CGSize(width: position.width, height: height)
                   }
                   .onEnded { value in
                       if value.translation.height < -200{
                           stopped = true
                            if let identifier = timerManager.identifier {
                                if let session = sessions.first(where: { $0.id == identifier }) {
                                    activeSession = session
                                    session.stopDate = Date()
                                    print(Date())
                                    do {
                                        try context.save()
                                        timerManager.deleteFirstPendingTimer(completion: { _ in })
                                        blockManager.stopMonitoring()
                                        isSessionFinished = true
                                    } catch {
                                        print("Error saving context: \(error)")
                                    }
                                } else {
                                    print("errore nell'aggiornare la sessione")
                                }
                            }
                           print("Task Complete")
                       }
                       else if value.translation.height > 200{
                           endSession(isCompleted: false)
                           print("Task Missed")
                       }
                       withAnimation {
                           isDragging = false
                           position = .zero
                           isHoldingCircle = false
                       }
                   }
               
        
        NavigationStack {
            ZStack{
                
                NavigationLink(destination: EndOFSession(session: activeSession), isActive: $isSessionFinished) {
                    EmptyView()
                }
                .hidden()
                .navigationBarHidden(true)
                .navigationBarBackButtonHidden(true)
                .animation(nil)
                
                colorScheme == .dark ? Color.black.edgesIgnoringSafeArea(.all) : Color(hex: "F2EFE9").edgesIgnoringSafeArea(.all)
                
                VStack{
                    Spacer()
                    Rectangle()
                        .fill(LinearGradient(gradient: Gradient(colors: [mainColor, mainColor.opacity(0.4), Color.clear]), startPoint: .bottom, endPoint: .top))
                        .frame(width: UIScreen.main.bounds.width, height: 150)
                        .foregroundColor(Color.blue)
                        .ignoresSafeArea()
                }.ignoresSafeArea()
                if let name = gifName{
                    ZStack{
                        if isHoldingCircle{
                            VStack(spacing:16){
                                Image(.check).resizable().renderingMode(.template).foregroundColor(colorScheme == .dark ? Color(hex: "F2EFE9") : .black) .scaledToFill().frame(width:30, height: 20)
                                Image(.line).resizable().renderingMode(.template).foregroundColor(colorScheme == .dark ? Color(hex: "F2EFE9") : .black).scaledToFill().frame(width:1, height: 400)
                                Image(.cross).resizable().renderingMode(.template).foregroundColor(colorScheme == .dark ? Color(hex: "F2EFE9") : .black).scaledToFill().frame(width: 18, height: 18)
                            }
                        }
                        
                        
                        GIFImage(name: name)
                            .offset(position)
                            .gesture(dragGesture)
                    }
                    
                    ZStack {
                        VStack{
                            //                            Text(".radical")
                            //                                .font(Font.custom("HelveticaNeue", size: 36))
                            //                                .fontWeight(.bold)
                            //                                .animation(nil)
                            //
                            Spacer().animation(nil)
                            
                            Text("Hai finito?")
                                .font(Font.custom("Montserrat", size: 36))
                                .fontWeight(.bold)
                                .textCase(.uppercase)
                                .animation(nil)
                                .opacity(isHoldingCircle ? 1 : 0)
                            //
                            //                            Text("Solleva il dito per riprendere:")
                            //                                .font(Font.custom("HelveticaNeue", size: 20))
                            //                                .animation(nil)
                            
                            Spacer().animation(nil)
                            
                            Spacer().animation(nil)
                            Spacer().animation(nil)
                            Spacer().animation(nil)
                            
                            Spacer().animation(nil)
                            
                            Text("\(categoryName)")
                                .font(Font.custom("HelveticaNeue", size: 36))
                                .fontWeight(.bold)
                                .textCase(.uppercase)
                                .animation(nil)
                            
                            Spacer().animation(nil)
                            
                            
                        }
                        
                        //LiquidCircle(width: UIScreen.main.bounds.width * 0.8, progress: $progress, color: mainColor)
                        
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
                        changeCategoryName(session.category!.name)
                        gifName = (session.category?.gifName ?? "") + "\(colorScheme == .dark ? "_dark" : "_light")"
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
                    // aggiunto da gio 06/03/2024
                    endSession(isCompleted: true)
                }
                
            }
        }
    }
    
    func endSession(isCompleted: Bool){
        stopTimer()
        blockManager.stopMonitoring()
        if let identifier = timerManager.identifier {
            if let session = sessions.first(where: { $0.id == identifier }) {
                activeSession = session
                let duration = session.timeGoal - timerManager.remainingTime
                session.stopDate = session.startDate.addingTimeInterval(duration)
                if isCompleted{
                    activeSession?.completeSession()
                }
                do {
                    try context.save()
                } catch {
                    print("Error saving context: \(error)")
                }
            } else {
                print("errore nell'aggiornare la sessione")
            }
            isSessionFinished = true
        }
        timerManager.deleteFirstPendingTimer(completion: { _ in })
    }
}



#Preview {
    RunningTimer()
}

// Users/lorenzovecchio/Library/Developer/Xcode/DerivedData/Project_Pegasus-fvvjapjltlafqwfhxdjvzpptfywj/
// Build/Products/Debug-iphoneos/PackageFrameworks/SwiftUIIntrospect-Dynamic.framework/SwiftUIIntrospect-Dynamic
