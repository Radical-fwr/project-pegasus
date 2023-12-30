//
//  HomeWheelSelectors.swift
//  Project Pegasus
//
//  Created by Lorenzo Vecchio on 30/12/23.
//

import SwiftUI

struct HomeWheelSelectors: View {
    var categories: [Category]
    @Binding var selectedCategory: Category?
    @Binding var selectedHour: Double?
    @Binding var selectedMinute: Double?
    
    var body: some View {
        ZStack {
            HStack {
                Picker("", selection: $selectedCategory) {
                    Text("TAG")
                        .foregroundColor(.white)
                        .font(Font.custom("HelveticaNeue", size: 35))
                        .fontWeight(.bold)
                        .tag(Category?.none)
                    ForEach(categories) { category in
                        Text(category.name.uppercased())
                            .foregroundColor(category == selectedCategory ? Color(hex: category.color) : .white)
                            .font(Font.custom("HelveticaNeue", size: 35))
                            .fontWeight(.bold)
                            .tag(Category?.some(category))
                    }
                }
                .pickerStyle(.wheel)
                .frame(width: UIScreen.main.bounds.width/2)
                .scaleEffect(CGSize(width: 1.50, height: 1.50))
                .introspect(.picker(style: .wheel), on: .iOS(.v13, .v14, .v15, .v16, .v17)) { picker in
                    picker.subviews[1].backgroundColor = UIColor.clear
                }
                
                Picker("", selection: $selectedHour) {
                    Text("00")
                        .foregroundColor(.white)
                        .font(Font.custom("HelveticaNeue", size: 35))
                        .fontWeight(.bold)
                        .tag(Double?.none)
                    ForEach(1...23, id: \.self) { hour in
                        Text(String(format: "%02d", hour))
                            .foregroundColor(.white)
                            .font(Font.custom("HelveticaNeue", size: 35))
                            .fontWeight(.bold)
                            .tag(Double?.some(Double(hour)))
                    }
                }
                .pickerStyle(.wheel)
                .scaleEffect(CGSize(width: 1.50, height: 1.50))
                .introspect(.picker(style: .wheel), on: .iOS(.v13, .v14, .v15, .v16, .v17)) { picker in
                    picker.subviews[1].backgroundColor = UIColor.clear
                }
                
                Text(":")
                    .foregroundColor(.white)
                    .font(Font.custom("IntegralCF-Bold", size: 40))
                
                Picker("", selection: $selectedMinute) {
                    Text("00")
                        .foregroundColor(.white)
                        .font(Font.custom("HelveticaNeue", size: 35))
                        .fontWeight(.bold)
                        .tag(Double?.none)
    //                        Text("ss")
    //                            .foregroundColor(.white)
    //                            .font(Font.custom("HelveticaNeue", size: 35))
    //                            .fontWeight(.bold)
    //                            .tag(Double?.some(Double(0.3)))
                    ForEach(1...59, id: \.self) { minute in
                        Text(String(format: "%02d", minute))
                            .foregroundColor(.white)
                            .font(Font.custom("HelveticaNeue", size: 35))
                            .fontWeight(.bold)
                            .tag(Double?.some(Double(minute)))
                    }
                }
                .pickerStyle(.wheel)
                .scaleEffect(CGSize(width: 1.50, height: 1.50))
                .introspect(.picker(style: .wheel), on: .iOS(.v13, .v14, .v15, .v16, .v17)) { picker in
                    picker.subviews[1].backgroundColor = UIColor.clear
                }
            }
            .frame(height: 130)
            .padding()
        }
    }
}
