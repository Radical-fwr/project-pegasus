//
//  AppDelegate.swift
//  Project Pegasus
//
//  Created by Lorenzo Vecchio on 19/12/23.
//

import SwiftUI
import SwiftData

class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    // Handle notification when the app is in the background or terminated
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let identifier = response.notification.request.identifier
        if let userInfo = response.notification.request.content.userInfo as? [String: Any] {
            if let isTimer = userInfo["isTimer"] as? Bool , isTimer {
                let context = Environment(\.modelContext)
                let fetchDescriptor = FetchDescriptor<Session>()
                do {
                    let sessions = try context.wrappedValue.fetch(fetchDescriptor)
                    if let session = sessions.first(where: { $0.id == identifier }) {
                        session.stopDate = session.startDate.addingTimeInterval(session.timeGoal)
                        do {
                            try context.wrappedValue.save()
                        } catch {
                            print("Error saving context: \(error)")
                        }
                    } else {
                        print("errore nell'aggiornare la sessione")
                    }
                } catch {
                    print("Error accessing context: \(error)")
                    return
                }
            }
        }
    }
}
