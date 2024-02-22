//
//  Profile.swift
//  Project Pegasus
//
//  Created by Lorenzo Vecchio on 14/11/23.
//

import SwiftUI
import SwiftData

struct Profile: View {
    @Environment(\.modelContext) private var context
    @Query var users: [User]
    @Query var categories: [Category]
    @State private var isSheetPresented: Bool = false
    @Query var sessions: [Session]
    
    
    var body: some View {
        NavigationStack {
            ZStack{
                Color.black.edgesIgnoringSafeArea(.all)
                VStack {
                    Text("Efficienza")
                        .font(.title)
                        .fontWeight(.bold)
                    CustomHistogramView(sessions: sessions)
                        .frame(maxWidth: UIScreen.main.bounds.size.width*0.70)
                        .padding(10)
                    
                    ScrollView{
                        ForEach(categories) { category in
                            CategoryWStats(
                                name: category.name.uppercased(),
                                color: Color(hex: category.color),
                                progress: category.progress
                            )
                            .frame(maxWidth: UIScreen.main.bounds.size.width*0.75)
                            .padding(5)
                        }
                    }
                    Spacer()
                    Text("+ Nuovo Tag")
                        .font(Font.custom("", size: 30))
                        .padding()
                        .onTapGesture {
                            isSheetPresented = true
                        }
                }
            }
        }
        .background(.black)
        .foregroundColor(.white)
        .sheet(isPresented: $isSheetPresented, onDismiss: {isSheetPresented = false}, content: {
            AddCategory(isPresented: $isSheetPresented).background(.black)
        })
    }
}



#Preview {
    return Profile()
}
