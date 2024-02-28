//
//  Histogram.swift
//  Project Pegasus
//
//  Created by Giovanni Ercolano on 17/02/24.
//

import SwiftUI

struct CustomHistogramView: View {
    let sessions: [Session]
    
    /// Calcola l'efficienza per sessione e restituisce l'efficienza in valore assoluto - By Gio
    private func calculateEfficiency(for session: Session) -> Double? {
        guard let stopDate = session.stopDate else { return nil }
        
        let timeSpent = stopDate.timeIntervalSince(session.startDate)
        let efficiency = timeSpent / session.timeGoal
        
        return efficiency > 1 ? 1 : efficiency
    }
    
    /// Calcola l'efficienza totale giornaliera facendo una media tra l'efficienza delle varie sessioni del giorno - By Gio
    private func dailyEfficiency() -> [Date: Double] {
        let groupedSessions = Dictionary(grouping: sessions) { session -> Date in
            Calendar.current.startOfDay(for: session.startDate)
        }
        
        var dailyEfficiency: [Date: Double] = [:]
        
        for (date, sessionsForDay) in groupedSessions {
            let efficiencies = sessionsForDay.compactMap { calculateEfficiency(for: $0) }
            let averageEfficiency = efficiencies.isEmpty ? 0 : efficiencies.reduce(0, +) / Double(efficiencies.count)
            dailyEfficiency[date] = averageEfficiency
        }
        
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let dateIntervals = [-2, -1, 0, 1, 2] 
        
        for dayOffset in dateIntervals {
            let targetDate = calendar.date(byAdding: .day, value: dayOffset, to: today)!
            if dailyEfficiency[targetDate] == nil || dailyEfficiency[targetDate] == 0 {
                dailyEfficiency[targetDate] = 0.05
            }
        }
        
        return dailyEfficiency
    }
    
    /// Label delle barre del grafico, in base al giorno c'è un valore diverso, per il giorno attuale compare scritto oggi - By Gio
    private func dayLabel(for date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        if dateFormatter.string(from: Date()) == dateFormatter.string(from: date) {
            return "Oggi"
        } else {
            let calendar = Calendar.current
            let dayOfWeek = calendar.component(.weekday, from: date)
            switch dayOfWeek {
            case 1: return "d"
            case 2: return "l"
            case 3: return "m"
            case 4: return "m"
            case 5: return "g"
            case 6: return "v"
            case 7: return "s"
            default: return ""
            }
        }
    }
    
    var body: some View {
        VStack {
            GeometryReader { geometry in
                let data = dailyEfficiency().sorted(by: { $0.key < $1.key })
                let width = geometry.size.width / CGFloat(data.count) - 8
                let maxHeight = geometry.size.height - 20
                
                ForEach(Array(data.enumerated()), id: \.element.key) { index, element in
                    let barHeight = maxHeight * CGFloat(element.value)
                    
                    Rectangle()
                        .fill(LinearGradient(gradient: Gradient(colors: [.black, .white]), startPoint: .bottom, endPoint: .top))
                        .frame(width: width, height: barHeight)
                        .clipShape(RoundedRectangle(cornerRadius: 5))
                        .offset(x: CGFloat(index) * (width + 8), y: maxHeight - barHeight)
                }

                
                Path { path in
                    let y = maxHeight + 1
                    path.move(to: CGPoint(x: 0, y: y))
                    path.addLine(to: CGPoint(x: geometry.size.width, y: y))
                }
                .stroke(LinearGradient(gradient: Gradient(colors: [.black, .white, .black]), startPoint: .leading, endPoint: .trailing), lineWidth: 2)
            }
            .frame(height: 200)
            
            HStack {
                ForEach(dailyEfficiency().keys.sorted(), id: \.self) { key in
                    Text(dayLabel(for: key))
                        .frame(maxWidth: .infinity)
                }
            }
        }
    }
}

#Preview {
    Profile()
}
