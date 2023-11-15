//
//  ContentView.swift
//  Project Pegasus
//
//  Created by Lorenzo Vecchio on 28/10/23.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.modelContext) private var context
    private var isFirstLoad: Bool {
        get {
            UserDefaults.standard.bool(forKey: "isFirstLoad")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "isFirstLoad")
        }
    }
    
    init() {
        if isFirstLoad {
            var user = User(nome: "Giorgio")
            do {
                context.insert(user)
                try context.save()
            } catch {
                print("Error saving context: \(error)")
            }
            
            isFirstLoad = false
        }
    }
    var body: some View {
        VStack {
            Start()
        }
    }
}

#Preview {
    ContentView()
}
