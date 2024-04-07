//
//  CalendarView.swift
//  Project Pegasus
//
//  Created by Hasan on 31/03/2024.
//

import SwiftUI



struct CalendarScreen: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    private let calendar: Calendar
    private let monthFormatter: DateFormatter
    private let dayFormatter: DateFormatter
    private let weekDayFormatter: DateFormatter
    private let fullFormatter: DateFormatter
    private let yearFormatter: DateFormatter
    
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
            colorScheme == .dark ? Color.black.ignoresSafeArea() : Color.white.ignoresSafeArea()
            
            VStack(spacing:17){
                HStack(alignment:.bottom){
                    Text("CALENDAR")
                        .font(Font.custom("Montserrat", size: 36).weight(.bold))
                    
                    Spacer()
                    R_button()
                        .foregroundColor(colorScheme == .dark ? .white : .black)
                        .onTapGesture {
                            self.presentationMode.wrappedValue.dismiss()
                        }
                }
                CalendarView(
                    calendar: calendar,
                    date: $selectedDate,
                    content: { date in
                        Button(action: { selectedDate = date }) {
                            Text(dayFormatter.string(from: date))
                                .foregroundColor(
                                    (calendar.isDateInToday(date) && !calendar.isDate(date, inSameDayAs: selectedDate))  ? .black :
                                            .white)
                            
                                .background(
                                     Color.init(hex: "#D3D3D3").frame(width: 35,height: 35)
                                        .opacity(calendar.isDateInToday(date) && !calendar.isDate(date, inSameDayAs: selectedDate) ? 1 : 0)
                                        .cornerRadius(10)
                                        
                                   
                                        
                                )
                                .background(content: {
                                    
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(LinearGradient(gradient: Gradient(colors: [.white, .white, .white.opacity(0.7)]), startPoint: .topLeading, endPoint: .bottomTrailing))
                                        .opacity(calendar.isDate(date, inSameDayAs: selectedDate) ? 1 : 0)
                                        .cornerRadius(10)
                                        .frame(width: 45,height: 45)
                                        
                                    
                                })
                                
                                .frame(height:50)
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
                                Text(monthFormatter.string(from: date))
                                    .font(.system(size: 20,weight: .medium))
                                
                                Text(yearFormatter.string(from: date))
                                    .font(.system(size: 14,weight: .light))
                                
                                
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
                Spacer()
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
                    .padding(.bottom,30)
                ForEach(days, id: \.self) { date in
                    if calendar.isDate(date, equalTo: month, toGranularity: .month) {
                        content(date)
                    } else {
                        trailing(date)
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
