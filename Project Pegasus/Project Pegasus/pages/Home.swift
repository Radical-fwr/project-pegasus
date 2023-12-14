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
                Color.black.edgesIgnoringSafeArea(.all)

                VStack {
                    TopBar()
                    Spacer()
                    Spacer()
                    HStack {
                        Picker("", selection: $selectedCategory) {
                            Text("TAG")
                                .foregroundColor(.white)
                                .font(Font.custom("HelveticaNeue", size: 35))
                                .fontWeight(.bold)
                                .tag(Category?.none)
                            ForEach(categories) { category in
                                Text(category.name.uppercased())
                                    .foregroundColor(category == selectedCategory ? Color(hex: category.color) : .white)
                                    .font(Font.custom("HelveticaNeue", size: 35))
                                    .fontWeight(.bold)
                                    .tag(Category?.some(category))
                            }
                        }
                        .pickerStyle(.wheel)
                        .frame(width: UIScreen.main.bounds.width/2)
                        .scaleEffect(CGSize(width: 1.50, height: 1.50))
                        .introspect(.picker(style: .wheel), on: .iOS(.v13, .v14, .v15, .v16, .v17)) { picker in
                            picker.subviews[1].backgroundColor = UIColor.clear
                        }
                        
                        Picker("", selection: $selectedHour) {
                            Text("00")
                                .foregroundColor(.white)
                                .font(Font.custom("HelveticaNeue", size: 35))
                                .fontWeight(.bold)
                                .tag(Double?.none)
                            ForEach(1...23, id: \.self) { hour in
                                Text(String(format: "%02d", hour))
                                    .foregroundColor(.white)
                                    .font(Font.custom("HelveticaNeue", size: 35))
                                    .fontWeight(.bold)
                                    .tag(Double?.some(Double(hour)))
                            }
                        }
                        .pickerStyle(.wheel)
                        .scaleEffect(CGSize(width: 1.50, height: 1.50))
                        .introspect(.picker(style: .wheel), on: .iOS(.v13, .v14, .v15, .v16, .v17)) { picker in
                            picker.subviews[1].backgroundColor = UIColor.clear
                        }
                        
                        Text(":")
                            .foregroundColor(.white)
                            .font(Font.custom("IntegralCF-Bold", size: 40))
                        
                        Picker("", selection: $selectedMinute) {
                            Text("00")
                                .foregroundColor(.white)
                                .font(Font.custom("HelveticaNeue", size: 35))
                                .fontWeight(.bold)
                                .tag(Double?.none)
                            ForEach(1...59, id: \.self) { minute in
                                Text(String(format: "%02d", minute))
                                    .foregroundColor(.white)
                                    .font(Font.custom("HelveticaNeue", size: 35))
                                    .fontWeight(.bold)
                                    .tag(Double?.some(Double(minute)))
                            }
                        }
                        .pickerStyle(.wheel)
                        .scaleEffect(CGSize(width: 1.50, height: 1.50))
                        .introspect(.picker(style: .wheel), on: .iOS(.v13, .v14, .v15, .v16, .v17)) { picker in
                            picker.subviews[1].backgroundColor = UIColor.clear
                        }
                    }
                    .frame(height: 130)
                    .padding()
                    Spacer()
                    HStack {
                        Text("tempo rimanente: \(timerManager.remainingTime)")
                        Spacer()
                        NavigationLink(destination: RunningTimer(), isActive: $timerIsActive) {
                            EmptyView()
                        }
                        .hidden()
                        Button(action: {
                            let newSession = Session(
                                category: selectedCategory,
                                startDate: Date(),
                                timeGoal: ((selectedHour ?? 0) * 60 * 60) + ((selectedMinute ?? 0) * 60)
                            )

                            context.insert(newSession)
                            do {
                                try context.save()
                            } catch {
                                print("Error saving context: \(error)")
                            }
                            timerManager.startTimer(
                                timeInterval: ((selectedHour ?? 0) * 60 * 60) + ((selectedMinute ?? 0) * 60),
                                identifier: newSession.id,
                                contentTitle: "Test",
                                contentBody: "Test"
                            )
                            timerManager.startUpdatingRemainingTime()
                            timerIsActive = true
                        }) {
                            Text("Start")
                                .foregroundColor(.black)
                                .padding()
                                .padding()
                                .background(Color.white)
                                .clipShape(Circle())
                                .overlay(
                                    Circle()
                                        .stroke(Color.black, lineWidth: 2)
                                )
                        }
                        .padding()
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
