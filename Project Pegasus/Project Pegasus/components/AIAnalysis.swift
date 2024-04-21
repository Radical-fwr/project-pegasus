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
            Text("Efficienza".uppercased())
                .font(Font.custom("Montserrat", size: 32).weight(.bold))
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding([.leading])
                .foregroundColor(colorScheme == .dark ? .white : .black)
            
            Text(daysSelected() ?? "Data non disponibile")
                .font(Font.custom("HelveticaNeue", size: 16))
                .foregroundColor(colorScheme == .dark ? .white.opacity(0.5) : .black.opacity(0.5))
                .frame(maxWidth: .infinity,alignment: .leading)
                .padding([.leading])
            
            ZStack {
                CustomHistogramView(sessions: sessions)
                    .frame(maxWidth: UIScreen.main.bounds.size.width*0.90)
                    .padding(10)
                
                Rectangle()
                    .fill(
                        LinearGradient(colors: [
                            colorScheme == .dark ? .black : Color(hex: "F2EFE9"),
                            colorScheme == .dark ? .black.opacity(0.3) : Color(hex: "F2EFE9").opacity(0.3),
                            .clear,
                            colorScheme == .dark ? .black.opacity(0.3) : Color(hex: "F2EFE9").opacity(0.3),
                            colorScheme == .dark ? .black : Color(hex: "F2EFE9")
                        ], startPoint: .leading, endPoint: .trailing)
                    )
                
            }
        }
    }
}
