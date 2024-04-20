//
//  HomeWheelSelectors.swift
//  Project Pegasus
//
//  Created by Lorenzo Vecchio on 30/12/23.
//

import SwiftUI

struct HomeWheelSelectors: View {
    @Environment(\.colorScheme) var colorScheme
    var categories: [Category]
    @Binding var selectedCategory: Category?
    @Binding var selectedHour: Double?
    @Binding var selectedMinute: Double?
    @State var selectedCategoryIndex = 0
    @State var selectedHourIndex = 0
    @State var selectedMinuteIndex = 0
    @State var animationIndex = 0
    var body: some View {
        ZStack {
            HStack(spacing:0){
                Picker("", selection: $selectedCategoryIndex) {
//                    Text("TAG")
//                        .foregroundColor(colorScheme == .dark ? .white : .black)
//                        .font(Font.custom("HelveticaNeue", size: 35))
//                        .fontWeight(.bold)
//                        .tag(Category?.none)
                    if !categories.isEmpty{
                        ForEach(0 ..< 200) { index  in
                            let category = categories[index % categories.count]
                            Text(category.name.uppercased())
                                .foregroundColor(index == animationIndex ? Color(hex: colorScheme == .dark ? category.color : category.darkColor) : colorScheme == .dark ? .white : .black)
                                .font(Font.custom("Montserrat", size: index == animationIndex ?  20 : 16))
                                .fontWeight(.bold)
                                .tag(Category?.some(category))
                                .onChange(of: selectedCategory) {
                                    if selectedCategoryIndex == index {
                                        withAnimation {
                                            animationIndex = index
                                        }
                                        
                                    }
                                }
                        }
                            
                            
                    }
//                    ForEach(categories) { category in
//                        Text(category.name.uppercased())
//                            .foregroundColor(category == selectedCategory ? Color(hex: category.color) : colorScheme == .dark ? .white : .black)
//                            .font(Font.custom("HelveticaNeue", size: 35))
//                            .fontWeight(.bold)
//                            .tag(Category?.some(category))
//                    }
                }
                .pickerStyle(.wheel)
                
                .scaleEffect(CGSize(width: 2, height: 2))
                .introspect(.picker(style: .wheel), on: .iOS(.v13, .v14, .v15, .v16, .v17)) { picker in
                    picker.subviews[1].backgroundColor = UIColor.clear
                }
                
                HStack(spacing:0) {
                    Picker("", selection: $selectedHourIndex) {
                        //                    Text("00")
                        //                        .foregroundColor(colorScheme == .dark ? .white : .black)
                        //                        .font(Font.custom("HelveticaNeue", size: 35))
                        //                        .fontWeight(.bold)
                        //                        .tag(Double?.none)
                        ForEach(0...230, id: \.self) { hour in
                            Text(String(format: "%02d", hour%24))
                                .foregroundColor(colorScheme == .dark ? .white : .black)
                                .font(Font.custom("Montserrat", size: hour == selectedHourIndex ?  24 : 20))
                                .fontWeight(.bold)
                                .tag(Double?.some(Double(hour)))
                        }
                    }
                    .pickerStyle(.wheel)
                    .scaleEffect(CGSize(width: 2, height: 2))
                    .introspect(.picker(style: .wheel), on: .iOS(.v13, .v14, .v15, .v16, .v17)) { picker in
                        picker.subviews[1].backgroundColor = UIColor.clear
                    }
                    
                    Text(":")
                        .foregroundColor(colorScheme == .dark ? .white : .black)
                        .font(Font.custom("IntegralCF-Bold", size: 40))
                    
                    Picker("", selection: $selectedMinuteIndex) {
                        //                    Text("00")
                        //                        .foregroundColor(colorScheme == .dark ? .white : .black)
                        //                        .font(Font.custom("HelveticaNeue", size: 35))
                        //                        .fontWeight(.bold)
                        //                        .tag(Double?.none)
                        //                        Text("ss")
                        //                            .foregroundColor(.white)
                        //                            .font(Font.custom("HelveticaNeue", size: 35))
                        //                            .fontWeight(.bold)
                        //                            .tag(Double?.some(Double(0.3)))
                        ForEach(0...600, id: \.self) { minute in
                            Text(String(format: "%02d", minute%60))
                                .foregroundColor(colorScheme == .dark ? .white : .black)
                                .font(Font.custom("Montserrat", size: minute == selectedMinuteIndex ?  24 : 20))
                                .fontWeight(.bold)
                                .tag(Double?.some(Double(minute)))
                        }
                    }
                    .pickerStyle(.wheel)
                    .scaleEffect(CGSize(width: 2, height: 2))
                    .introspect(.picker(style: .wheel), on: .iOS(.v13, .v14, .v15, .v16, .v17)) { picker in
                        picker.subviews[1].backgroundColor = UIColor.clear
                    }
                }
            } .frame(height: 115)
            
            VStack{
                LinearGradient(gradient: Gradient(colors: [.shade, .clear]), startPoint: .top, endPoint: .bottom)
                    .frame(height:25)
                Spacer()
                LinearGradient(gradient: Gradient(colors: [.shade, .clear]), startPoint: .bottom, endPoint: .top)
                    .frame(height:25)
            }
            .frame(height: 150)
            
            VStack{
                Rectangle()
                    .fill(colorScheme == .dark ? Color.black : Color(hex: "F2EFE9"))
                    .frame(height:25)
                Spacer()
                Rectangle()
                    .fill(colorScheme == .dark ? Color.black : Color(hex: "F2EFE9"))
                    .frame(height:25)
            }
            .frame(height: 200)
           
        }
       
        .padding(.horizontal,33)
        .onChange(of: selectedHourIndex, {
           
                selectedHourIndex = 24  + (selectedHourIndex % 24)
                selectedHour = Double(selectedHourIndex % 24)
          
        })
        .onChange(of: selectedMinuteIndex, {
                selectedMinuteIndex = 60  + (selectedMinuteIndex % 60)
                selectedMinute = Double(selectedMinuteIndex % 60)
        })
        .onChange(of: selectedCategoryIndex, {
            
            selectedCategoryIndex = 100  + (selectedCategoryIndex % categories.count)
            selectedCategory = categories[selectedCategoryIndex % categories.count]
        })
        .onAppear {
            selectedCategoryIndex = 100 + categories.count
            selectedHourIndex = 24
            selectedMinuteIndex = 60
        }
        
       
    }
    
    func valueChanged(_ value: Int) {
            print("Minutes: \(value)")
        }
}
