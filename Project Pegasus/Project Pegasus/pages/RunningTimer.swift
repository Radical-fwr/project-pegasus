//
//  RunningTimer.swift
//  Project Pegasus
//
//  Created by Lorenzo Vecchio on 14/12/23.
//

import SwiftUI

struct RunningTimer: View {
    @StateObject var timerManager = TimerManager()
    
    var body: some View {
        NavigationStack {
            VStack{
                Text("tempo: \(timerManager.remainingTime)")
            }
        }
    }
}
