//
//  AnalysisCarousel.swift
//  Project Pegasus
//
//  Created by Giovanni Ercolano on 15/03/24.
//

import SwiftUI

struct AnalysisCarousel: View {
    @Environment(\.colorScheme) var colorScheme
    var categories: [Category]
    
    var body: some View {
        TabView {
            ForEach(categories, id: \.id) { category in
                GeometryReader { geometry in
                    VStack {
                        HStack{
                            Text("Sessione ideale di:")
                                .font(.callout)
                                .foregroundColor(colorScheme == .dark ? .white : .black)
                            Spacer()
                            Text(category.name.uppercased())
                                .font(.title)
                                .bold()
                                .foregroundColor(Color(hex: category.color))
                        }.padding(.bottom,30)
                        HStack{
                            Text("orario ideale per iniziare:")
                                .font(.callout)
                                .foregroundColor(colorScheme == .dark ? .white : .black)
                            Spacer()
                            Text("14:00")
                                .font(.callout)
                                .bold()
                                .foregroundColor(Color(hex: category.color))
                        }
                        .padding(.bottom)
                        HStack{
                            Text("Durata più efficace: ")
                                .font(.callout)
                                .foregroundColor(colorScheme == .dark ? .white : .black)
                            Spacer()
                            Text("3 H")
                                .font(.callout)
                                .bold()
                                .foregroundColor(Color(hex: category.color))
                        }
                        .padding(.bottom)
                        HStack{
                            Text("Valutazione media: ")
                                .font(.callout)
                                .foregroundColor(colorScheme == .dark ? .white : .black)
                            Spacer()
                            Text("3.5/5")
                                .font(.callout)
                                .bold()
                                .foregroundColor(Color(hex: category.color))
                        }
                    }
                    .padding(.horizontal,35)
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .cornerRadius(20)
                    .background(LinearGradient(gradient: Gradient(colors: [.black, Color(hex: category.color).opacity(0.7)]), startPoint: .topLeading, endPoint: .bottomTrailing))
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(LinearGradient(gradient: Gradient(colors: [Color(hex: category.color).opacity(0.7)]), startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 1)
                    )
                }
                .cornerRadius(20)
                .padding(.horizontal,2)
            }
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
        .cornerRadius(20)
        .frame(height: 300)
        .padding()
    }
}

#Preview {
    Profile()
}
