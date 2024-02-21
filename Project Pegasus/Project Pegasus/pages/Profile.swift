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
    //@Query var sessions: [Session] 
    let sessions : [Session]
    
    init() {
            var calendar = Calendar.current
            calendar.timeZone = TimeZone.current

            let today = Date()
            let twoDaysBeforeToday = calendar.date(byAdding: .day, value: -2, to: today)!
            let oneDayBeforeToday = calendar.date(byAdding: .day, value: -1, to: today)!
            let oneDayAfterToday = calendar.date(byAdding: .day, value: +1, to: today)!
            let twoDayAfterToday = calendar.date(byAdding: .day, value: +2, to: today)!
        
            self.sessions = [
                Session(startDate: twoDaysBeforeToday, stopDate: twoDaysBeforeToday.addingTimeInterval(1800), timeGoal: 3600),
                Session(startDate: oneDayBeforeToday, stopDate: oneDayBeforeToday.addingTimeInterval(800), timeGoal: 3600),
                Session(startDate: today, stopDate: today.addingTimeInterval(36000), timeGoal: 36000),
                Session(startDate: oneDayAfterToday, stopDate: oneDayAfterToday.addingTimeInterval(0.5), timeGoal: 10),
                Session(startDate: twoDayAfterToday, stopDate: twoDayAfterToday.addingTimeInterval(0.5), timeGoal: 10),
            ]
        }
    
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
    Profile()
}
