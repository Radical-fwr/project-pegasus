//
//  Start.swift
//  Project Pegasus
//
//  Created by Lorenzo Vecchio on 28/10/23.
//

import SwiftUI
import SwiftData

struct Start: View {
    @Environment(\.modelContext) private var context
    @Query var categories: [Category]
    @State private var isClicked: Bool = false
    @State private var isSheetPresented: Bool = false
    
    var body: some View{
        NavigationStack{
            ZStack{
                Color.black.edgesIgnoringSafeArea(.all)
                
                Text("00:00")
                    .font(Font.custom("IntegralCF-Regular", size: 190))
                    .foregroundColor(.gray.opacity(0.4))
                    .fixedSize(horizontal: true, vertical: false)
                    .rotationEffect(Angle(degrees: -90))
                    .padding(.leading, -40)
                
                LinearGradient(
                    gradient: Gradient(colors: [Color.black.opacity(0.0), Color.black.opacity(1), Color.black.opacity(1), Color.black.opacity(0.0)]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(width: UIScreen.main.bounds.width, height: 500)

                if (!isClicked) {
                    Text("radical.")
                        .font(Font.custom("HelveticaNeue", size: 38))
                        .foregroundColor(.white)
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                }
                
                VStack{
                    HStack{
                        Spacer()
                        NavigationLink(destination: Profile()) {
                            Text("r.")
                                .font(Font.custom("HelveticaNeue", size: 40))
                                .foregroundColor(.white)
                                .padding()
                        }
                        
                    }.frame(width: UIScreen.main.bounds.width)
                    
                    Text("Ciao,\ncosa ti porta qui?")
                        .font(Font.custom("HelveticaNeue", size: 38))
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                    
                    ForEach(categories) { category in
                        Button(category.name) {
                            
                        }
                        .buttonStyle(CategoryButtonStyle(color: Color.init(category.color)))
                    }
                    
                    Button("Add...") {
                        isSheetPresented = true
                    }
                    .buttonStyle(CategoryButtonStyle(color: .gray))
                    
                    Spacer()
                }
                .offset(y: isClicked ? 0 : UIScreen.main.bounds.height)
                
            }
            .onTapGesture {
                withAnimation(.easeInOut(duration: 0.5)) {
                    isClicked.toggle()
                }
            }
            .sheet(isPresented: $isSheetPresented, onDismiss: {isSheetPresented = false}, content: {
                AddCategory(isPresented: $isSheetPresented).background(.black)
            })
        }
    }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
    
}

#Preview {
    Start()
}
