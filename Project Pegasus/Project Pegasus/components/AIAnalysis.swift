//
//  AIAnalysis.swift
//  Project Pegasus
//
//  Created by Lorenzo Vecchio on 21/04/24.
//

import SwiftUI
import SwiftData

struct AIAnalysis: View {
    @Environment(\.colorScheme) var colorScheme
    @Query var sessions: [Session]
    @State var expanded: Bool = false
    
    private func daysSelected() -> String? {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let dateIntervals = [-2, -1, 0, 1, 2]
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM"
        
        let dates = dateIntervals.map { daysOffset in
            calendar.date(byAdding: .day, value: daysOffset, to: today)!
        }
        
        let formattedDates = dates.map { dateFormatter.string(from: $0) }
        
        if let firstDate = formattedDates.first, let lastDate = formattedDates.last {
            let resultString = "\(firstDate) - \(lastDate)"
            return resultString // Ritorna la stringa dell'intervallo di date.
        }
        
        return nil // Ritorna nil se non è possibile calcolare l'intervallo.
    }
    
    
    var body: some View {
        VStack{
            Text("ai analysis".uppercased())
                .font(Font.custom("Montserrat", size: 32).weight(.bold))
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding([.leading])
                .foregroundColor(colorScheme == .dark ? .white : .black)
            
            if expanded {
                CategoriesInfo(expanded: $expanded)
            } else {
                Text(daysSelected() ?? "Data non disponibile")
                    .font(Font.custom("Helvetica Neue", size: 16))
                    .foregroundColor(colorScheme == .dark ? .white.opacity(0.5) : .black.opacity(0.5))
                    .frame(maxWidth: .infinity,alignment: .leading)
                    .padding([.leading])
                
                ZStack {
                    VStack{
                        Spacer().frame(height: 235)
                        ExpandButton(expanded: $expanded)
                    }.padding()
                    
                    CustomHistogramView(sessions: sessions)
                    
                }
            }
        }
    }
}


struct ExpandButton: View {
    @Environment(\.colorScheme) var colorScheme
    @Binding var expanded: Bool
    
    var body: some View {
        ZStack{
            ZStack {
                Rectangle()
                    .fill(LinearGradient(colors: colorScheme == .dark ? [.clear, .white.opacity(0.3), .clear] : [Color(hex: "BFB48F").opacity(0.6), .clear], startPoint: .leading, endPoint: .trailing))
                    .frame(height: 80)
                    .cornerRadius(15)
                
                RoundedRectangle(cornerRadius: 15)
                    .stroke(style: StrokeStyle(lineWidth: 1))
                    .foregroundColor(colorScheme == .dark ? Color.black.opacity(1) : Color.white.opacity(0.5))
                
            }
            RoundedRectangle(cornerRadius: 15)
                .fill(LinearGradient(colors: [
                    .clear,
                    colorScheme == .dark ? .black : Color(hex: "F2EFE9").opacity(0.3),
                ], startPoint: .bottom, endPoint: .top))
            
            Rectangle()
                .fill(
                    LinearGradient(colors: [
                        .clear,
                        colorScheme == .dark ? .black : Color(hex: "F2EFE9").opacity(1),
                        colorScheme == .dark ? .black : Color(hex: "F2EFE9").opacity(1),
                    ], startPoint: .bottom, endPoint: .top)
                    //Color.blue
                )
                .frame(height: 25)
                .offset(y: -30)
            
            HStack{
                Spacer()
                Text("Categories analysis")
                    .font(Font.custom("Helvetica Neue", size: 16))
                    .foregroundColor(colorScheme == .dark ? .white : .black)
                Spacer()
                Image("arrow-up-large")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundStyle(colorScheme == .dark ? Color.white : Color.black)
                    .frame(width: 15)
            }
            .padding()
            .padding()
            .offset(y: 10)
        }.onTapGesture {
            expanded = true
        }
    }
}

struct CategoriesInfo: View {
    @Environment(\.colorScheme) var colorScheme
    @Binding var expanded: Bool
    @State var currentCategory = 0
    @Query var categories: [Category]
    @Query var sessions: [Session]
    
    private var averageRating: Int {
        let thisCatSessions = sessions.filter{ session in session.category!.id == categories[currentCategory].id }
        if thisCatSessions.count == 0 {
            return 0
        } else {
            let sum = thisCatSessions.reduce(0) { $0 + $1.rating }
            return Int(Double(sum) / Double(thisCatSessions.count))
        }
    }
    
    private var idealHour: String {
        let thisCatSessions = sessions.filter{ session in session.category!.id == categories[currentCategory].id }
        let calendar = Calendar.current
        var hourCounts = [Int: Int]()
        for obj in thisCatSessions {
            let hour = calendar.component(.hour, from: obj.startDate)
            if let count = hourCounts[hour] {
                hourCounts[hour] = count + 1
            } else {
                hourCounts[hour] = 1
            }
        }
        var mostCommonHour: Int = 0
        var highestCount = 0
        for (hour, count) in hourCounts {
            if count > highestCount {
                mostCommonHour = hour
                highestCount = count
            }
        }
        return String(format: "%02d", mostCommonHour)
        
    }
    
    private var idealDuration: String {
        let thisCatSessions = sessions.filter{ session in session.category!.id == categories[currentCategory].id }
        let calendar = Calendar.current
        var durationCounts = [Double: Int]()
        for obj in thisCatSessions {
            let duration = obj.stopDate!.timeIntervalSince(obj.startDate)
            if let count = durationCounts[duration] {
                durationCounts[duration] = count + 1
            } else {
                durationCounts[duration] = 1
            }
        }
        var mostCommonDuration: Double = 0
        var highestCount = 0
        for (duration, count) in durationCounts {
            if count > highestCount {
                mostCommonDuration = duration
                highestCount = count
            }
        }
        let seconds = Int(mostCommonDuration)
        let hours = seconds / 3600
        let minutes = (seconds % 3600) / 60
        return "\(hours) H \(minutes) M"
    }
    
    private var weekDayEfficency: [Double] {
        // Get the current calendar and today's date
        let calendar = Calendar.current
        let today = Date()
        // Get the start and end dates of the current week
        let startDate = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: today))!
        // get sessions
        let thisCatSessions = sessions.filter{ session in session.category!.id == categories[currentCategory].id }
        
        var result: [Double] = []
        
        for i in 0...6 {
            // find sessions of each day of week
            let dayOfWeek = calendar.date(byAdding: .day, value: i, to: startDate)!
            let sessionsOfDay = thisCatSessions.filter{ session in
                calendar.isDate(session.startDate, inSameDayAs: dayOfWeek)
            }
            if !sessionsOfDay.isEmpty {
                // calc average progress of day
                let sessionsOfDayLength = Double(sessionsOfDay.count)
                var total: Double = 0
                for session in sessionsOfDay {
                    total += session.progress
                }
                result.append(total / sessionsOfDayLength)
            } else {
                result.append(0)
            }
        }
        return result
    }
    
    var body: some View {
        TabView(selection: $currentCategory) {
            ForEach(categories) { category in
                VStack{
                    HStack{
                        /// Title
                        Spacer()
                        Text("General analysis")
                            .font(Font.custom("Helvetica Neue", size: 16))
                        Spacer()
                        Image("arrow-up-large")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .foregroundStyle(colorScheme == .dark ? Color.white : Color.black)
                            .frame(width: 20)
                            .rotationEffect(Angle(degrees: 180))
                    }
                    .onTapGesture {
                        expanded = false
                    }
                    .padding()
                    
                    Line()
                        .stroke(style: StrokeStyle(lineWidth: 2, dash: [20]))
                        .frame(height: 2)
                        .foregroundStyle(colorScheme == .light ? Color(hex: category.darkColor).opacity(0.8) : Color(hex: category.color).opacity(0.8))
                        .padding(EdgeInsets(top: 0, leading: 30, bottom: 0, trailing: 30))
                    
                    Text("\(category.name.uppercased())")
                        .font(Font.custom("Montserrat", size: 36))
                        .fontWeight(.bold)
                        .foregroundStyle(Color(hex: colorScheme == .light ? category.darkColor : category.color))
                    
                    Graph(color: Color(hex: colorScheme == .light ? category.darkColor : category.color), data: weekDayEfficency)
                    
                    Text("Weekly Efficiency")
                        .font(Font.custom("Helvetica Neue", size: 12))
                    
                    VStack{
                        HStack{
                            Text("Orario ideale per iniziare")
                                .font(Font.custom("Helvetica Neue", size: 16))
                            Spacer()
                            Text("\(idealHour).00")
                                .font(Font.custom("Montserrat", size: 15))
                                .fontWeight(.bold)
                                .foregroundStyle(Color(hex: colorScheme == .light ? category.darkColor : category.color))
                        }.padding(EdgeInsets(top: 5, leading: 30, bottom: 5, trailing: 30))
                        
                        HStack{
                            Text("Durata più efficace")
                                .font(Font.custom("Helvetica Neue", size: 16))
                            Spacer()
                            Text("\(idealDuration)")
                                .font(Font.custom("Montserrat", size: 15))
                                .fontWeight(.bold)
                                .foregroundStyle(Color(hex: colorScheme == .light ? category.darkColor : category.color))
                        }.padding(EdgeInsets(top: 5, leading: 30, bottom: 5, trailing: 30))
                        
                        HStack{
                            Text("Valutazione media")
                                .font(Font.custom("Helvetica Neue", size: 16))
                            Spacer()
                            Text("\(averageRating)/5")
                                .font(Font.custom("Montserrat", size: 15))
                                .fontWeight(.bold)
                                .foregroundStyle(Color(hex: colorScheme == .light ? category.darkColor : category.color))
                        }.padding(EdgeInsets(top: 5, leading: 30, bottom: 5, trailing: 30))
                    }
                    .padding()
                    
                    Spacer()
                }.tag(categories.firstIndex(of: category) ?? 0)
            }
        }
        .tabViewStyle(.page)
        .background(LinearGradient(colors: colorScheme == .light ? [Color(hex: categories[currentCategory].darkColor).opacity(0.09), Color(hex: categories[currentCategory].darkColor).opacity(0.45)] : [Color(hex: categories[currentCategory].color).opacity(0.09), Color(hex: categories[currentCategory].color).opacity(0.45)],
                                   startPoint: .leading, endPoint: .trailing).cornerRadius(10))
        .frame(height: 480)
        .padding()
        .foregroundStyle(colorScheme == .dark ? Color.white : Color.black)
    }
}


struct Line: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: rect.width, y: 0))
        return path
    }
}
