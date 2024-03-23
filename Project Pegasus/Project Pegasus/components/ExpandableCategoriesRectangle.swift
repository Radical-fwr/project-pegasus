//
//  ExpandableRectangle.swift
//  Project Pegasus
//
//  Created by Giovanni Ercolano on 11/03/24.
//

import SwiftUI

struct ExpandableCategoriesRectangle: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Binding var isExpanded: Bool
    // var lightColor = "BFB48F"
    let activities: [Activity]
    let categories: [Category]
    let darkGradient = LinearGradient(
        stops: [
            Gradient.Stop(color: Color(red: 0.53, green: 0.53, blue: 0.53).opacity(0.5), location: 0.00),
            Gradient.Stop(color: Color(red: 0.53, green: 0.53, blue: 0.53).opacity(0.35), location: 1.00),
        ],
        startPoint: UnitPoint(x: 0, y: 0),
        endPoint: UnitPoint(x: 1, y: 1)
    )
    @Binding var isSheetPresented: Bool
    
    var body: some View {
        NavigationStack {
            VStack {
                ScrollView(showsIndicators: false){
                    ForEach(Array(categories.enumerated()), id: \.offset) { index, category in
                        if index < (isExpanded ? categories.count : 2) {
                            NavigationLink(destination: CategoryDetail(categoryId: category.id ,categoryName: category.name.uppercased(), categoryColor: Color(hex: category.color), category: category, activity: activities)) {
                                CategoryWStats(
                                    name: category.name.uppercased(),
                                    color: Color(hex: category.color),
                                    progress: category.progress,
                                    gradient: colorScheme == .dark ? darkGradient : nil,
                                    useColorScheme: false,
                                    backgroundColor: colorScheme == .dark ? nil : .white
                                )
                            }
                            .padding(.top, index == 0 ? 10 : 0)
                            .padding(.bottom, index == (isExpanded ? categories.count : 2) - 1 ? 10 : 0)
                        }
                    }
                    if isExpanded {
                        Text("+ Nuovo Tag")
                            .font(Font.custom("HelveticaNeue", size: 24))
                            .foregroundColor(colorScheme == .dark ? .white : .white)
                            .padding(.horizontal)
                            .padding(.top,10)
                            .padding(.bottom,20)
                            .onTapGesture {
                                isSheetPresented = true
                            }
                        
                    }
                }
                .frame(height: isExpanded ? 327 : 135 )
            }
            .frame(maxWidth: .infinity)

            .padding(.horizontal, 15)
            .background(
                colorScheme == .dark ? AnyView(
                    LinearGradient(gradient: Gradient(colors: [.black,.gray.opacity(0.2),.white.opacity(0.2),.gray.opacity(0.2),.black]), startPoint: .leading, endPoint: .trailing)
                ) : AnyView(
                    LinearGradient(
                    stops: [
                        Gradient.Stop(color: Color(red: 0.75, green: 0.71, blue: 0.56).opacity(0.7), location: 0.00),
                        Gradient.Stop(color: Color(red: 0.75, green: 0.71, blue: 0.56).opacity(0.3), location: 1.00),
                    ],
                    startPoint: UnitPoint(x: 0, y: 0.5),
                    endPoint: UnitPoint(x: 1, y: 0.5)
                    )
                )
            )
            .cornerRadius(10)
            .shadow(color: colorScheme == .dark ? Color(red: 0.37, green: 0.37, blue: 0.37) : Color.white, radius: 0, x: 0, y: isExpanded ? 0 : colorScheme == .dark ? 4 : 0)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(colorScheme == .dark ? .gray : .white, lineWidth: 1)
            )
            .animation(.easeInOut, value: isExpanded)
            .padding(.horizontal)
        }
        .navigationBarTitle("")
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
    }
}
//RadialGradient(gradient: Gradient(colors: [.black, .white.opacity(0.4)]), center: .center, startRadius: 250, endRadius: 2)
#Preview {
    return Profile()
}

