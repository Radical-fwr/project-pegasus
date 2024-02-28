//
//  FilterButton.swift
//  Project Pegasus
//
//  Created by Giovanni Ercolano on 28/02/24.
//

import SwiftUI

struct FilterButton: View {
    let title: String
    let filterType: FilterType
    @Binding var selectedFilter: FilterType
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        Button(action: {
            selectedFilter = filterType
            presentationMode.wrappedValue.dismiss()
        }) {
            Text(title)
                .font(.title2.bold())
                .padding(.top,15)
                .foregroundColor(selectedFilter == filterType || selectedFilter == .null ? .white : .white.opacity(0.5))
        }
    }
}

