//
//  timer.swift
//  Project Pegasus
//
//  Created by Lorenzo Vecchio on 07/12/23.
//

import SwiftUI

class TimerManager: ObservableObject {
    
    private let center = UNUserNotificationCenter.current()
    private var timer: Timer?
    @Published var remainingTime: Double = 0.0
    
    init(){}
    
    func requestNotificationPermission() {
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print(error)
            }
        }
    }
    
    func startTimer(timeInterval: Double, identifier: String, contentTitle: String, contentBody: String) {
        let content = UNMutableNotificationContent()
        content.title = contentTitle
        content.body = contentBody
        content.userInfo = [
            "isTimer": true,
            "expire": Date().addingTimeInterval(timeInterval)
        ]
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: (timeInterval), repeats: false)
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        center.add(request) { (error) in
           if error != nil {
              print("ERRORE NEL SETTARE NOTIFICA")
           }
        }
    }
    
    func checkActiveTimerExistence(completion: @escaping (Bool) -> Void) {
        center.getPendingNotificationRequests { requests in
            let activeTimerExists = requests.contains { request in
                if let userInfo = request.content.userInfo as? [String: Any],
                   let isTimer = userInfo["isTimer"] as? Bool, isTimer {
                    return true
                }
                return false
            }
            completion(activeTimerExists)
        }
    }
    
    private func getFirstPendingTimerIdentifier(completion: @escaping (String?) -> Void) {
        center.getPendingNotificationRequests { requests in
            if let timerIdentifier = requests.first(where: { request in
                if let userInfo = request.content.userInfo as? [String: Any],
                   let isTimer = userInfo["isTimer"] as? Bool, isTimer {
                    return true
                }
                return false
            })?.identifier {
                completion(timerIdentifier)
            } else {
                completion(nil)
            }
        }
    }
    
    func startUpdatingRemainingTime() {
        // Invalidate existing timer to avoid multiple timers
        timer?.invalidate()
        
        // Set up a new timer to update remaining time every second
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            self.updateRemainingTime()
        }
        
        // Ensure the timer is added to the current run loop
        RunLoop.current.add(timer!, forMode: .common)
    }
        
    private func updateRemainingTime() {
        getFirstPendingTimerIdentifier { identifier in
            guard let identifier = identifier else {
                // No active timer, set remainingTime to 0
                DispatchQueue.main.sync{
                    self.remainingTime = 0.0
                }
                return
            }

            // Get the time remaining for the active timer
            self.center.getPendingNotificationRequests { requests in
                if let request = requests.first(where: { $0.identifier == identifier }) {
                    var expire: Date = Date()
                    if let userInfo = request.content.userInfo as? [String: Any],
                       let expireDate = userInfo["expire"] as? Date {
                        expire = expireDate
                    }

                    DispatchQueue.main.sync{
                        self.remainingTime = expire.timeIntervalSinceNow
                    }
                }
            }
        }
    }
}
