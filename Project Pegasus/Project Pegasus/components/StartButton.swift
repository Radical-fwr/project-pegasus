//
//  StartButton.swift
//  Project Pegasus
//
//  Created by Lorenzo Vecchio on 30/12/23.
//

import SwiftUI
import SwiftData

struct StartButton: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.modelContext) private var context
    @Binding var selectedCategory: Category?
    @Binding var selectedActivity: Activity?
    @Binding var selectedHour: Double?
    @Binding var selectedMinute: Double?
    @Binding var timerIsActive: Bool
    @Binding var slideReverse: Bool
    @StateObject var timerManager = TimerManager()
    
    @StateObject var blockManager = BlockManager.shared
    
    var body: some View {
        if selectedCategory != Category?.none && (selectedHour != Double?.none || selectedMinute != Double?.none) {
            Button(action: {
                let timeInterval = ((selectedHour ?? 0) * 60 * 60) + ((selectedMinute ?? 0) * 60)
                if timeInterval == 0{
                    return
                }
                let newSession = Session(
                    category: selectedCategory,
                    activity: selectedActivity,
                    startDate: Date(),
                    timeGoal: timeInterval
                )

                context.insert(newSession)
                do {
                    try context.save()
                } catch {
                    print("Error saving context: \(error)")
                }
                timerManager.startTimer(
                    timeInterval: timeInterval,
                    sessionIdentifier: newSession.id,
                    contentTitle: "TIMER TERMINATO!!!!",
                    contentBody: "Sei riuscito ad arrivare alla fine della tua sessione in: \(selectedCategory!.name.uppercased())"
                )
                blockManager.initiateMonitoring(timeInterval: timeInterval)
                slideReverse = false
                timerIsActive = true
            }) {
                Text("Start")
                    .font(Font.custom("HelveticaNeue", size: 27))
                    .fontWeight(.bold)
                    .foregroundColor(colorScheme == .dark ? .black : .white)
                    .padding()
                    .padding()
                    .background(LinearGradient(gradient: Gradient(colors: [
                        colorScheme == .dark ? .white : .black,
                        colorScheme == .dark ? .white.opacity(0.7) : .black.opacity(0.7)
                    ]), startPoint: .leading, endPoint: .trailing))
                    .clipShape(Circle())
                    .overlay(
                        Circle()
                            .stroke(colorScheme == .dark ? Color.black : Color(hex: "F2EFE9"), lineWidth: 2)
                    )
            }
            .padding()
        } else {
            Button(action: {}) {
                Text("Start")
                    .font(Font.custom("HelveticaNeue", size: 27))
                    .fontWeight(.bold)
                    .foregroundColor(colorScheme == .dark ? .black : .white)
                    .padding()
                    .padding()
                    .background(colorScheme == .dark ? Color.gray : Color.black.opacity(0.7))
                    .clipShape(Circle())
                    .overlay(
                        Circle()
                            .stroke(colorScheme == .dark ? Color.black : Color(hex: "F2EFE9"), lineWidth: 2)
                    )
            }
            .padding()
        }
    }
}
