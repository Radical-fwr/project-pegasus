//
//  BlockManager.swift
//  Project Pegasus
//
//  Created by Lorenzo Vecchio on 05/03/24.
//

import Foundation
import FamilyControls
import DeviceActivity
import ManagedSettings

class BlockManager: ObservableObject {
    static let shared = BlockManager()
    let store = ManagedSettingsStore()
    
    private init() {}
    
    var selectionToDiscourage = FamilyActivitySelection() {
        willSet {
            let applications = newValue.applicationTokens
            let categories = newValue.categoryTokens
            let webCategories = newValue.webDomainTokens
            store.shield.applications = applications.isEmpty ? nil : applications
            store.shield.applicationCategories = ShieldSettings.ActivityCategoryPolicy.specific(categories, except: Set())
            store.shield.webDomainCategories = ShieldSettings.ActivityCategoryPolicy.specific(categories, except: Set())
        }
    }
    
    func initiateMonitoring(timeInterval: TimeInterval) {
        let end = Date().addingTimeInterval(timeInterval)
        let endComponents = Calendar.current.dateComponents([.hour, .minute], from: end)
        let schedule = DeviceActivitySchedule(intervalStart: DateComponents(hour: 0, minute: 0), intervalEnd: endComponents, repeats: false, warningTime: nil)
        
        let center = DeviceActivityCenter()
        do {
            try center.startMonitoring(.once, during: schedule)
        }
        catch {
            print ("Could not start monitoring \(error)")
        }
    }
    
    func stopMonitoring() {
        let center = DeviceActivityCenter()
        center.stopMonitoring()
        // aggiunto da gio 06/03/2024
        store.shield.applications = nil
        store.shield.applicationCategories = ShieldSettings.ActivityCategoryPolicy.none
        store.shield.webDomainCategories = ShieldSettings.ActivityCategoryPolicy.none
    }
    
}

extension DeviceActivityName {
    static let once = Self("once")
}
