//
//  Home.swift
//  Project Pegasus
//
//  Created by Lorenzo Vecchio on 30/11/23.
//

import SwiftUI
import SwiftData
import SwiftUIIntrospect

struct Home: View {
    @Environment(\.modelContext) private var context
    @Query var categories: [Category]
    @State private var selectedCategory: Category?
    @State private var selectedHour: Double?
    @State private var selectedMinute: Double?
    @State private var timerIsActive: Bool = false
    @StateObject var timerManager = TimerManager()
        
    var body: some View {
        NavigationStack {
            ZStack {
                
                NavigationLink(destination: RunningTimer(), isActive: $timerIsActive) {
                    EmptyView()
                }
                .hidden()
                .navigationBarHidden(true)
                .navigationBarBackButtonHidden(true)
                
                Color.black.edgesIgnoringSafeArea(.all)

                VStack {
                    TopBar()
                    Spacer()
                    Spacer()
                    HomeWheelSelectors(
                        categories: categories,
                        selectedCategory: $selectedCategory,
                        selectedHour: $selectedHour,
                        selectedMinute: $selectedMinute
                    )
                    Spacer()
                    HStack {
                        Spacer()
                        StartButton(
                            selectedCategory: $selectedCategory,
                            selectedHour: $selectedHour,
                            selectedMinute: $selectedMinute,
                            timerIsActive: $timerIsActive
                        )
                    }
                    Spacer()
                    HStack{
                        //bottom bar
                    }
                }
            }
        }
        .background(.black)
        .foregroundColor(.white)
        .onAppear() {
            
            if timerManager.checkActiveTimerExistenceSync() {
                let delayInSeconds: Double = 0.01
                DispatchQueue.main.asyncAfter(deadline: .now() + delayInSeconds) {
                    timerIsActive = true
                }
            }
        }
    }
}

#Preview{
    let container = try! ModelContainer(for: Category.self, User.self, Session.self)
    let testUser: User = User(nome: "Giorgio")
    let category1: Category = Category(name: "study", color: "EC8E14")
    let category2: Category = Category(name: "work", color: "F6DE00")
    let category3: Category = Category(name: "detox", color: "F9DEFF")
    container.mainContext.insert(testUser)
    container.mainContext.insert(category1)
    container.mainContext.insert(category2)
    container.mainContext.insert(category3)
    return Home()
        .modelContainer(container)
}
