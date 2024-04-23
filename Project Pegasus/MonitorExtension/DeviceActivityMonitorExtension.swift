//
//  DeviceActivityMonitorExtension.swift
//  MonitorExtension
//
//  Created by Lorenzo Vecchio on 05/03/24.
//

import MobileCoreServices
import ManagedSettings
import DeviceActivity
import SwiftUI

class Monitor: DeviceActivityMonitor {
    let store = ManagedSettingsStore()
    override func intervalDidStart(for activity: DeviceActivityName) {
        super.intervalDidStart(for: activity)
//        let model = BlockManager.shared
//        let applications = model.selectionToDiscourage.applicationTokens
//        store.shield.applications = applications.isEmpty ? nil : applications
    }
    // modificato da nil a Optional.none da gio 06/03/2024
    override func intervalDidEnd(for activity: DeviceActivityName) {
        super.intervalDidEnd(for: activity)
//        store.shield.applications = nil
//        store.shield.applicationCategories = ShieldSettings.ActivityCategoryPolicy.none
//        store.shield.webDomainCategories = ShieldSettings.ActivityCategoryPolicy.none
//        store.shield.webDomains = .none
//        BlockManager.shared.stopMonitoring()
//        let center = DeviceActivityCenter()
//        center.stopMonitoring()
    }
    // modificato da nil a Optional.none da gio 06/03/2024
    override func eventDidReachThreshold(_ event: DeviceActivityEvent.Name, activity: DeviceActivityName) {
        super.eventDidReachThreshold(event, activity: activity)
//        store.shield.applications = nil
//        store.shield.applicationCategories = ShieldSettings.ActivityCategoryPolicy.none
//        store.shield.webDomainCategories = ShieldSettings.ActivityCategoryPolicy.none
//        store.shield.webDomains = .none
//        BlockManager.shared.stopMonitoring()
//        let center = DeviceActivityCenter()
//        center.stopMonitoring()
    }
}
