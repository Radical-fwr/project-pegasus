//
//  StartButton.swift
//  Project Pegasus
//
//  Created by Lorenzo Vecchio on 30/12/23.
//

import SwiftUI
import SwiftData

struct StartButton: View {
    @Environment(\.modelContext) private var context
    @Binding var selectedCategory: Category?
    @Binding var selectedSubCategory: SubCategory?
    @Binding var selectedHour: Double?
    @Binding var selectedMinute: Double?
    @Binding var timerIsActive: Bool
    @StateObject var timerManager = TimerManager()
    
    var body: some View {
        if selectedCategory != Category?.none && (selectedHour != Double?.none || selectedMinute != Double?.none) {
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
                    sessionIdentifier: newSession.id,
                    contentTitle: "TIMER TERMINATO!!!!",
                    contentBody: "Sei riuscito ad arrivare alla fine della tua sessione in: \(selectedCategory!.name.uppercased())"
                )
                timerIsActive = true
            }) {
                Text("Start")
                    .font(Font.custom("HelveticaNeue", size: 27))
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
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
        } else {
            Button(action: {}) {
                Text("Start")
                    .font(Font.custom("HelveticaNeue", size: 27))
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                    .padding()
                    .padding()
                    .background(Color.gray)
                    .clipShape(Circle())
                    .overlay(
                        Circle()
                            .stroke(Color.black, lineWidth: 2)
                    )
            }
            .padding()
        }
    }
}
