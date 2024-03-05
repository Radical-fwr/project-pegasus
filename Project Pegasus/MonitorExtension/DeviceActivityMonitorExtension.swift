//
//  DeviceActivityMonitorExtension.swift
//  MonitorExtension
//
//  Created by Lorenzo Vecchio on 05/03/24.
//

import MobileCoreServices
import ManagedSettings
import DeviceActivity

class Monitor: DeviceActivityMonitor {
    let store = ManagedSettingsStore()
    override func intervalDidStart(for activity: DeviceActivityName) {
        super.intervalDidStart(for: activity)
        let model = BlockManager.shared
        let applications = model.selectionToDiscourage.applicationTokens
        store.shield.applications = applications.isEmpty ? nil : applications
        print("start monitoring")
    }

    override func intervalDidEnd(for activity: DeviceActivityName) {
        super.intervalDidEnd(for: activity)
        store.shield.applications = nil
        store.shield.applicationCategories = nil
        store.shield.webDomainCategories = nil
        store.shield.webDomains = nil
    }
    
    override func eventDidReachThreshold(_ event: DeviceActivityEvent.Name, activity: DeviceActivityName) {
        super.eventDidReachThreshold(event, activity: activity)
        store.shield.applications = nil
        store.shield.applicationCategories = nil
        store.shield.webDomainCategories = nil
        store.shield.webDomains = nil
    }
}
