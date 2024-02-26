//
//  timer.swift
//  Project Pegasus
//
//  Created by Lorenzo Vecchio on 07/12/23.
//

import SwiftUI
import SwiftData

class TimerManager: ObservableObject {
    
    private let center = UNUserNotificationCenter.current()
    private var timer: Timer?
    @Published var remainingTime: Double = 0.0
    var identifier: String?

    init(){}
    
    func requestNotificationPermission() {
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print(error)
            }
        }
    }
    
    func startTimer(timeInterval: Double, sessionIdentifier: String, contentTitle: String, contentBody: String) {
        let content = UNMutableNotificationContent()
        content.title = contentTitle
        content.body = contentBody
        content.userInfo = [
            "isTimer": true,
            "expire": Date().addingTimeInterval(timeInterval),
            "sessionIdentifier": sessionIdentifier
        ]
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: (timeInterval), repeats: false)
        let request = UNNotificationRequest(identifier: sessionIdentifier, content: content, trigger: trigger)
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
    
    func checkActiveTimerExistenceSync() -> Bool {
        var result: Bool = false
        let semaphore = DispatchSemaphore(value: 0)

        center.getPendingNotificationRequests { requests in
            let activeTimerExists = requests.contains { request in
                if let userInfo = request.content.userInfo as? [String: Any],
                   let isTimer = userInfo["isTimer"] as? Bool, isTimer {
                    return true
                }
                return false
            }
            result = activeTimerExists
            semaphore.signal()
        }

        _ = semaphore.wait(timeout: .distantFuture)
        return result
    }
    
    func getFirstPendingTimerIdentifier(completion: @escaping (String?) -> Void) {
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
    
    func deleteNotification(withIdentifier identifier: String, completion: @escaping (Error?) -> Void) {
        center.removePendingNotificationRequests(withIdentifiers: [identifier])
        completion(nil)
    }

    
    func deleteFirstPendingTimer(completion: @escaping (Error?) -> Void) {
        getFirstPendingTimerIdentifier { identifier in
            if let identifier = identifier {
                self.deleteNotification(withIdentifier: identifier, completion: completion)
            } else {
                completion(nil) // Notify that no timer was found
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
            
            self.identifier = identifier

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
