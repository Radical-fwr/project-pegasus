//
//  Home.swift
//  Project Pegasus
//
//  Created by Lorenzo Vecchio on 30/11/23.
//

import SwiftUI
import SwiftData
import SwiftUIIntrospect
import NavigationTransitions

struct Home: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.modelContext) private var context
    @Query var categories: [Category]
    @State private var selectedCategory: Category?
    @State private var selectedSubCategory: SubCategory?
    @State private var selectedHour: Double?
    @State private var selectedMinute: Double?
    @State private var timerIsActive: Bool = false
    @StateObject var timerManager = TimerManager()
    @State var isSubCategoriesDisplayExpanded : Bool = false
    @State var streakPosition: Double = 0
    @State var slideReverse: Bool = false
    @State var navToSettings: Bool = false
    @State var navToProfile: Bool = false
        
    var body: some View {
        NavigationStack {
            ZStack {
                
                NavigationLink(destination: RunningTimer(), isActive: $timerIsActive) {
                    EmptyView()
                }
                .hidden()
                .navigationBarHidden(true)
                .navigationBarBackButtonHidden(true)
                
                colorScheme == .dark ? Color.black.edgesIgnoringSafeArea(.all) : Color(hex: "F2EFE9").edgesIgnoringSafeArea(.all)

                VStack {
                    TopBar(navToSettings: $navToSettings, navToProfile: $navToProfile)
                    Spacer()
                    Spacer()
                    ZStack{
                        HomeWheelSelectors(
                            categories: categories,
                            selectedCategory: $selectedCategory,
                            selectedHour: $selectedHour,
                            selectedMinute: $selectedMinute
                        )
                        DelimitationBars()
                    }
                   // Spacer()
                    VStack{
                        HStack {
                            SubCategoriesDisplay(category: selectedCategory, opened: $isSubCategoriesDisplayExpanded, selectedSubCategory: $selectedSubCategory)
                            //.padding()
                                .padding(.leading, 30)
                            //.padding()
                            
                            if !isSubCategoriesDisplayExpanded{
                               // Spacer()
                                StartButton(
                                    selectedCategory: $selectedCategory,
                                    selectedSubCategory: $selectedSubCategory,
                                    selectedHour: $selectedHour,
                                    selectedMinute: $selectedMinute,
                                    timerIsActive: $timerIsActive,
                                    slideReverse: $slideReverse
                                )
                                .scaledToFill()
                            }
                        }
                        //Spacer()
                    }.frame(height: 250)
                    NavigationLink {
                        CalendarScreen(calendar: .current)
                    } label: {
                        WeeklyView()
                    }
                    
                }
            }
            
        }
        .navigationTransition(slideReverse ? .reverseSlide(axis: .horizontal) : .slide(axis: .horizontal))
        .onChange(of: navToProfile) {
            slideReverse = false
        }
        .onChange(of: navToSettings) {
            slideReverse = true
        }
        .background(colorScheme == .dark ? .black : Color(hex: "F2EFE9"))
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
    let container = try! ModelContainer(for: Category.self, User.self, Session.self, SubCategory.self)
    let category1: Category = Category(name: "study", color: "EC8E14", gifName: "orange")
    let category2: Category = Category(name: "work", color: "F6DE00", gifName: "yellow")
    let category3: Category = Category(name: "detox", color: "F9DEFF", gifName: "green")
    container.mainContext.insert(category1)
    container.mainContext.insert(category2)
    container.mainContext.insert(category3)
    return Home()
        .modelContainer(container)
}

