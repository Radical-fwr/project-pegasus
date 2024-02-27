//
//  FilterSheetView.swift
//  Project Pegasus
//
//  Created by Giovanni Ercolano on 27/02/24.
//

import SwiftUI

struct FilterSheetView: View {
    @Binding var selectedFilter: FilterType
    @Environment(\.presentationMode) var presentationMode
    
    let gradient = LinearGradient(gradient: Gradient(colors: [Color.black, Color.black.opacity(0.5)]), startPoint: .leading, endPoint: .trailing)
    
    var body: some View {
        VStack(spacing: 0) {
            
            Button(action: {
                selectedFilter = .date
                presentationMode.wrappedValue.dismiss()
            }) {
                Text("DATA")
                    .font(.title2.bold())
                    .padding(.top,15)
                    .foregroundColor(selectedFilter == .date ? .white : .gray)
            }
            
            Button(action: {
                selectedFilter = .alphabetical
                presentationMode.wrappedValue.dismiss()
            }) {
                Text("A-Z")
                    .font(.title2.bold())
                    .padding(.top,15)
                    .foregroundColor(selectedFilter == .alphabetical ? .white : .gray)
            }
            
            Button(action: {
                selectedFilter = .efficiency
                presentationMode.wrappedValue.dismiss()
            }) {
                Text("EFFICIENZA")
                    .font(.title2.bold())
                    .padding(.top,15)
                    .foregroundColor(selectedFilter == .efficiency ? .white : .gray)
            }
            
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Text("Annulla")
                    .font(.callout.bold())
                    .padding(.top,15)
                    .foregroundColor(.gray)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .frame(height: 380)
        .background(gradient)
        .cornerRadius(30)
    }
}



