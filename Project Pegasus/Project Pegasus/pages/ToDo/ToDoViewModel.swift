//
//  ToDoViewModel.swift
//  Project Pegasus
//
//  Created by Hasan on 14/04/2024.
//

import Foundation
import SwiftData
import SwiftUI

class ToDoViewModel: ObservableObject{
    //
    @Published var newActivityName = ""
    @Published var newDateString = ""
    @Published var addSubCategory = false
    private var oldDateString = ""
    
    func formatDate(){
        if newDateString.count > 5{
            newDateString = newDateString.prefix(5).lowercased()
        }
        
        let chars = Array(newDateString)
        if oldDateString.count == 2 && newDateString.count == 3{
            newDateString = "\(chars[0])\(chars[1])/\(chars[2])"
        }
        if oldDateString.count == 4 && newDateString.count == 3{
            newDateString = "\(chars[0])\(chars[1])"
        }
        oldDateString = newDateString
    }
    
    func createActivityIfNeeded( context: ModelContext,category:Category){
        if newDateString.count != 5 || newActivityName == ""{
            return
        }
        let dateSplit = newDateString.split(separator: "/")
        if dateSplit.count != 2{
            return
        }
        guard let day = Int(dateSplit[0]) else{return}
        guard let month = Int(dateSplit[1]) else{return}
        
        let activity = Activity(category: category, title: newActivityName, day: day, month: month)
        context.insert(activity)
        newDateString = ""
        newActivityName = ""
        addSubCategory = false
        do {
            try context.save()
        } catch {
            print("Error saving context: \(error)")
        }
    }
}
