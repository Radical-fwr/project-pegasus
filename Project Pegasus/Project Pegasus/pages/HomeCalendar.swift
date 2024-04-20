//
//  HomeCalendar.swift
//  Goals
//
//  Created by Hasan on 10/01/2024.

import SwiftUI

struct DateIndex {
    var index: Int
    var date: Date
}

struct WeeklyView: View {
    @State var selectedDate: Date = Date()
    @State var proxy: ScrollViewProxy?
    
    var body: some View {
            
            ZStack{
               
                LazyHStack {
                    Spacer()
                    ForEach(dateRange(), id: \.index) { dateIndex in
                        WeeklyDayView(date: dateIndex.date, selectedDate: $selectedDate)
                            .padding()
                    }
                    Spacer()
                }
                HStack{
                    LinearGradient(gradient: Gradient(colors: [.shade, .clear]), startPoint: .leading, endPoint: .trailing)
                        .frame(width:150)
                    Spacer()
                    LinearGradient(gradient: Gradient(colors: [.shade, .clear]), startPoint: .trailing, endPoint: .leading)
                        .frame(width:150)
                }
            }
            .frame(height: 80)
    }
    
    
    
    func dateRange() -> [DateIndex] {
        var dates: [DateIndex] = []
        //var currentDate = startDate
        let calendar = Calendar.current
        //calendar.firstWeekday = 2
        let date = Date()
        var currentDate = date.addingTimeInterval(-86400 * 2)
        
        for i in 0...4 {
            
            dates.append(DateIndex(index: i, date:currentDate))
            currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate)!
        }
        return dates
    }
}

struct WeeklyDayView: View {
    let date: Date
    @Binding var selectedDate: Date
    let dateFormatter = DateFormatter()
    @State var weekdayName = ""
    //@State var grade: String = "-"
    var body: some View {
        
//        Button {
//            selectedDate = date
//        } label: {
            
            VStack(alignment: .center, spacing: 2) {
                if isToday(date){
                    Text(weekdayName.uppercased())
                    
                    
                        .font(.system(size: 12,weight: .medium))
                        .padding(.horizontal, 12)
                    Color.white.frame(height: 1)
                }
                
                Text("\(dayOfMonth(date))")
                    .font(.system(size: 24,weight: .medium))
                
            }
           
            .padding(.vertical, 6)
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .inset(by: 1)
                    .stroke(.white, lineWidth: 2)
                    .opacity(isToday(date) ? 1 : 0)
            )
            .foregroundColor(.white)
        //}
        .onAppear{
            dateFormatter.dateFormat = "EEE"
            weekdayName = dateFormatter.string(from: date)
          
        }
        
        
        
    }
    
    func dayOfMonth(_ date: Date) -> String {
        let dayFormatter = DateFormatter()
        dayFormatter.dateFormat = "d"
        return dayFormatter.string(from: date)
    }
    
    func isToday(_ date: Date) -> Bool {
        return Calendar.current.isDateInToday(date)
    }
}
struct WeeklyView_Previews: PreviewProvider {
    static var previews: some View {
        WeeklyView()
    }
}
