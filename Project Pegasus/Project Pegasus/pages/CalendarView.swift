//
//  CalendarView.swift
//  Project Pegasus
//
//  Created by Hasan on 31/03/2024.
//

import SwiftUI
import SwiftData

struct CalendarScreen: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    private let calendar: Calendar
    private let monthFormatter: DateFormatter
    private let dayFormatter: DateFormatter
    private let weekDayFormatter: DateFormatter
    private let fullFormatter: DateFormatter
    private let yearFormatter: DateFormatter
    @Query var activites: [Activity]

    @State private var selectedDate = Self.now
    private static var now = Date() // Cache now
    
    init(calendar: Calendar) {
        self.calendar = calendar
        self.monthFormatter = DateFormatter(dateFormat: "MMMM", calendar: calendar)
        self.dayFormatter = DateFormatter(dateFormat: "d", calendar: calendar)
        self.weekDayFormatter = DateFormatter(dateFormat: "EEE", calendar: calendar)
        self.fullFormatter = DateFormatter(dateFormat: "MMMM dd, yyyy", calendar: calendar)
        self.yearFormatter = DateFormatter(dateFormat: "yyyy", calendar: calendar)
    }
    
    var body: some View {
        ZStack{
            colorScheme == .dark ? Color.black.edgesIgnoringSafeArea(.all) : Color(hex: "F2EFE9").edgesIgnoringSafeArea(.all)
            
            VStack(spacing:17){
                CalendarView(
                    calendar: calendar,
                    date: $selectedDate,
                    content: { date in
                        Button(action: { selectedDate = date }) {
                            VStack(alignment: .center, content: {
                                Text(dayFormatter.string(from: date))
                                    //.foregroundColor((calendar.isDateInToday(date) && !calendar.isDate(date, inSameDayAs: selectedDate))  ? .black : .white)
                                    .foregroundStyle(Color(colorScheme == .dark ? .white : .black))
                            })
                            .background(
                                Color.init(hex: "#D3D3D3")
                                    .frame(width: 35, height: 35)
                                    .opacity(calendar.isDateInToday(date) && !calendar.isDate(date, inSameDayAs: selectedDate) ? 1 : 0)
                                    .cornerRadius(10)
                            )
                            .overlay(
                                GeometryReader { geometry in
                                    ZStack {
                                        if calendar.component(.day, from: date) >= calendar.component(.day, from: Date()) {
                                            HStack(spacing: 5) {
                                                ForEach(Array(activites.prefix(4).enumerated()), id: \.element) { index, activity in
                                                    if activity.day == calendar.component(.day, from: date) && activity.month == calendar.component(.month, from: date) {
                                                        Circle()
                                                            .fill(Color(hex: colorScheme == .dark ? activity.category.color : activity.category.darkColor))
                                                            .frame(width: 8, height: 8)
                                                    }
                                                }
                                            }
                                            .frame(width: geometry.size.width, height: 15) // Regola l'altezza per i cerchi
                                            .position(x: geometry.size.width / 2, y: geometry.size.height)
                                        }
                                    }
                                }
                                .frame(width: 35, height: 35)
                            )
                            .background(
                                content: {
                                    if (calendar.isDate(date, inSameDayAs: selectedDate)){
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(LinearGradient(gradient: Gradient(colors: [.white, .white, .white.opacity(0.7)]), startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 3)
                                            .opacity(calendar.isDate(date, inSameDayAs: selectedDate) ? 1 : 0)
                                            .cornerRadius(10)
                                            .frame(width: 50, height: 50)
                                    }else{
                                        ForEach(activites) { activity in
                                            if calendar.component(.day, from: date) < calendar.component(.day, from: Date()) {
                                                        let activitiesForDate = activites.filter { $0.day == calendar.component(.day, from: date) }
                                                let activiiesForMonth = activites.filter{ $0.month == calendar.component(.month, from: date)}
                                                if !activitiesForDate.isEmpty && !activiiesForMonth.isEmpty{
                                                            Circle()
                                                                .fill(Color(hex: activitiesForDate[0].category.color))
                                                                .frame(width: 35, height: 35)
                                                        }
                                                    }
                                        }
                                    }
                                }
                            )
                            .frame(height: 50)
                            .accessibilityHidden(true)
                        }
                    },
                    trailing: { date in
                        Text(dayFormatter.string(from: date))
                            .foregroundColor(.secondary)
                    },
                    header: { date in
                        Text(weekDayFormatter.string(from: date))
                            .font(.system(size: 14,weight: .medium))
                    },
                    title: { date in
                        HStack {
                            Button {
                                withAnimation {
                                    guard let newDate = calendar.date(
                                        byAdding: .month,
                                        value: -1,
                                        to: selectedDate
                                    ) else {
                                        return
                                    }
                                    
                                    selectedDate = newDate
                                }
                            } label: {
                                Label(
                                    title: { Text("Previous") },
                                    icon: { Image(systemName: "chevron.left") }
                                )
                                .labelStyle(IconOnlyLabelStyle())
                                .padding(.horizontal)
                                .frame(maxHeight: .infinity)
                            }
                            
                            Spacer()
                            
                            VStack(spacing:0){
                                Text(monthFormatter.string(from: date).uppercased())
                                    .font(.system(size: 32,weight: .bold))
                                
                                Text(yearFormatter.string(from: date))
                                    .font(.system(size: 16,weight: .light))
                                
                            }

                            Spacer()
                            
                            Button {
                                withAnimation {
                                    guard let newDate = calendar.date(
                                        byAdding: .month,
                                        value: 1,
                                        to: selectedDate
                                    ) else {
                                        return
                                    }
                                    
                                    selectedDate = newDate
                                }
                            } label: {
                                Label(
                                    title: { Text("Next") },
                                    icon: { Image(systemName: "chevron.right") }
                                )
                                .labelStyle(IconOnlyLabelStyle())
                                .padding(.horizontal)
                                .frame(maxHeight: .infinity)
                            }
                            
                            
                        }
                        .padding(.bottom, 6)
                    }
                    
                )
                .equatable()
                .font(.system(size: 24, weight: .medium))
                //lista attività della giornata
                    ForEach(activites) { activity in
                        if (activity.day == calendar.component(.day, from: selectedDate) && activity.month == calendar.component(.month, from: selectedDate))
                        {
                            Rectangle()
                                .fill(LinearGradient(gradient: Gradient(colors: [colorScheme == .dark ? Color.black.opacity(0.3) : Color.white.opacity(0.3),Color(hex: colorScheme == .dark ? activity.category.color : activity.category.darkColor).opacity(0.3),Color(hex: colorScheme == .dark ? activity.category.color : activity.category.darkColor).opacity(0.5)]), startPoint: .leading, endPoint: .trailing))
                                .frame(width: 330, height: 70)
                                .overlay(
                                    HStack {
                                        VStack(alignment: .leading, content: {
                                            Text(activity.category.name.uppercased())
                                                .foregroundStyle(Color(hex: colorScheme == .dark ? activity.category.color : activity.category.darkColor))
                                                .font(
                                                    Font.custom("Montserrat", size: 20)
                                                        .weight(.bold)
                                                )
                                            Text(activity.title)
                                                .foregroundStyle(Color(colorScheme == .dark ? .white : .black))
                                                .font(
                                                    Font.custom("Helvetica Neue", size: 16)
                                                        .weight(.medium)
                                                )
                                        })
                                        Spacer()
                                        VStack(alignment: .trailing, content: {
                                            let dateFormatter: DateFormatter = {
                                                let formatter = DateFormatter()
                                                formatter.dateFormat = "dd.MM.yyyy"
                                                return formatter
                                            }()
                                            Text(selectedDate, formatter: dateFormatter)
                                                .foregroundStyle(Color(colorScheme == .dark ? .white : .black))
                                                .font(
                                                    Font.custom("HelveticaNeue", size: 14)
                                                        .weight(.light)
                                                )
                                            Spacer()
                                        })
                                    }
                                    .padding(10)
                                    
                                )
                                .cornerRadius(10)
                                .padding(5)
                        }
                    }

            }
            .foregroundColor(colorScheme == .dark ? .white : .black)
            .padding()
        }
        .navigationBarBackButtonHidden()
        
    }
}



// MARK: - Component

public struct CalendarView<Day: View, Header: View, Title: View, Trailing: View>: View {
    // Injected dependencies
    private var calendar: Calendar
    @Binding private var date: Date
    private let content: (Date) -> Day
    private let trailing: (Date) -> Trailing
    private let header: (Date) -> Header
    private let title: (Date) -> Title
    
    // Constants
    private let daysInWeek = 7
    
    public init(
        calendar: Calendar,
        date: Binding<Date>,
        @ViewBuilder content: @escaping (Date) -> Day,
        @ViewBuilder trailing: @escaping (Date) -> Trailing,
        @ViewBuilder header: @escaping (Date) -> Header,
        @ViewBuilder title: @escaping (Date) -> Title
    ) {
        self.calendar = calendar
        self._date = date
        self.content = content
        self.trailing = trailing
        self.header = header
        self.title = title
    }
    
    public var body: some View {
        let month = date.startOfMonth(using: calendar)
        let days = makeDays()
        
        return LazyVGrid(columns: Array(repeating: GridItem(), count: daysInWeek)) {
            Section(header: title(month)) {
                ForEach(days.prefix(daysInWeek), id: \.self, content: header)
                    .padding(.bottom,5)
                ForEach(days, id: \.self) { date in
                    if calendar.isDate(date, equalTo: month, toGranularity: .month) {
                        content(date)
                            .padding(-5)
                    } else {
                        trailing(date)
                            .padding(-5)
                    }
                }
            }
        }
    }
}

// MARK: - Conformances

extension CalendarView: Equatable {
    public static func == (lhs: CalendarView<Day, Header, Title, Trailing>, rhs: CalendarView<Day, Header, Title, Trailing>) -> Bool {
        lhs.calendar == rhs.calendar && lhs.date == rhs.date
    }
}

// MARK: - Helpers

private extension CalendarView {
    func makeDays() -> [Date] {
        guard let monthInterval = calendar.dateInterval(of: .month, for: date),
              let monthFirstWeek = calendar.dateInterval(of: .weekOfMonth, for: monthInterval.start),
              let monthLastWeek = calendar.dateInterval(of: .weekOfMonth, for: monthInterval.end - 1)
        else {
            return []
        }
        
        let dateInterval = DateInterval(start: monthFirstWeek.start, end: monthLastWeek.end)
        return calendar.generateDays(for: dateInterval)
    }
}

private extension Calendar {
    func generateDates(
        for dateInterval: DateInterval,
        matching components: DateComponents
    ) -> [Date] {
        var dates = [dateInterval.start]
        
        enumerateDates(
            startingAfter: dateInterval.start,
            matching: components,
            matchingPolicy: .nextTime
        ) { date, _, stop in
            guard let date = date else { return }
            
            guard date < dateInterval.end else {
                stop = true
                return
            }
            
            dates.append(date)
        }
        
        return dates
    }
    
    func generateDays(for dateInterval: DateInterval) -> [Date] {
        generateDates(
            for: dateInterval,
            matching: dateComponents([.hour, .minute, .second], from: dateInterval.start)
        )
    }
}

private extension Date {
    func startOfMonth(using calendar: Calendar) -> Date {
        calendar.date(
            from: calendar.dateComponents([.year, .month], from: self)
        ) ?? self
    }
}

private extension DateFormatter {
    convenience init(dateFormat: String, calendar: Calendar) {
        self.init()
        self.dateFormat = dateFormat
        self.calendar = calendar
    }
}

// MARK: - Previews
/*
#if DEBUG
struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CalendarScreen(calendar: Calendar(identifier: .gregorian))
            CalendarScreen(calendar: Calendar(identifier: .islamicUmmAlQura))
            CalendarScreen(calendar: Calendar(identifier: .hebrew))
            CalendarScreen(calendar: Calendar(identifier: .indian))
        }
    }
}
#endif
 */


#if DEBUG
struct CalendarScreen_Preview: PreviewProvider{
    
    static var previews: some View{
        Group{
            CalendarScreen(calendar: Calendar(identifier: .gregorian))
        }
    }
}
#endif
