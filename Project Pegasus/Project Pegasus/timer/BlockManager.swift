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
    
    var selectionToDiscourage: FamilyActivitySelection {
        get {
            let decoder = PropertyListDecoder()
            guard let data = UserDefaults.standard.data(forKey: "shieldSelection") else {
                return FamilyActivitySelection()
            }
            let selectedApplications = try? decoder.decode(FamilyActivitySelection.self, from: data)
            if let selectedApplications = selectedApplications {
                return selectedApplications
            } else {
                return FamilyActivitySelection()
            }
        }
        set {
            let encoder = PropertyListEncoder()
            UserDefaults.standard.set(try? encoder.encode(newValue), forKey: "shieldSelection")
            let applications = newValue.applicationTokens
            let categories = newValue.categoryTokens
            let web = newValue.webDomainTokens
//            store.shield.applications = applications.isEmpty ? nil : applications
//            store.shield.applicationCategories = ShieldSettings.ActivityCategoryPolicy.specific(categories, except: Set())
//            store.shield.webDomainCategories = ShieldSettings.ActivityCategoryPolicy.specific(categories, except: Set())
        }
    }
    
    func initiateMonitoring(timeInterval: TimeInterval) {
        store.shield.applications = selectionToDiscourage.applicationTokens
        store.shield.applicationCategories = ShieldSettings.ActivityCategoryPolicy.specific(selectionToDiscourage.categoryTokens, except: Set())
        store.shield.webDomainCategories = ShieldSettings.ActivityCategoryPolicy.specific(selectionToDiscourage.categoryTokens, except: Set())
        
        
        let startComponents = Calendar.current.dateComponents([.hour, .minute], from: Date())
        let end = Date().addingTimeInterval(timeInterval)
        let endComponents = Calendar.current.dateComponents([.hour, .minute], from: end)
        print(endComponents)
        let schedule = DeviceActivitySchedule(intervalStart: DateComponents(hour: 0, minute: 0), intervalEnd: endComponents, repeats: false, warningTime: nil)
        let event = DeviceActivityEvent(
            applications: selectionToDiscourage.applicationTokens,
            categories: selectionToDiscourage.categoryTokens,
            webDomains: selectionToDiscourage.webDomainTokens,
            threshold: DateComponents(second: Int(timeInterval))
        )
        let eventName = DeviceActivityEvent.Name("Radical.end")
        let name = DeviceActivityName("Radical.start")
        
        let center = DeviceActivityCenter()
        do {
            try center.startMonitoring(name, during: schedule, events: [eventName: event])
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
    static let once = Self("Radical.start")
}
