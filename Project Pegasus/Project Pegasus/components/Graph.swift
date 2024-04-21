//
//  Graph.swift
//  Project Pegasus
//
//  Created by Lorenzo Vecchio on 19/04/24.
//

import SwiftUI
import Charts

struct Graph: View {
    var color: Color
    var data: [Double]
    
    
    var body: some View {
        VStack{
            Chart{
                
                PointMark(x: .value("day", 0), y: .value("percent", 1))
                    .foregroundStyle(Color.clear)
                
                ForEach(0..<data.count, id: \.self) { i in
                    LineMark(
                        x: .value("day", i),
                        y: .value("percent", data[i])
                    )
                }
                .interpolationMethod(.cardinal)
                .foregroundStyle(color)
                .lineStyle(StrokeStyle(lineWidth: 2.5, lineCap: .round))
                
                ForEach(0..<data.count, id: \.self) { i in
                    AreaMark(
                        x: .value("day", i),
                        y: .value("percent", data[i])
                    )
                }
                .interpolationMethod(.cardinal)
                .foregroundStyle(LinearGradient(gradient: Gradient(colors: [color.opacity(0.6), .clear]), startPoint: .top, endPoint: .bottom))
            }
            .frame(height: 120)
            .padding(EdgeInsets(top: 15, leading: 15, bottom: 0, trailing: 15))
            .chartXScale(domain: .automatic)
            .chartYScale(domain: .automatic)
            .chartXAxis {
                AxisMarks(position: .bottom, values: [0, 1, 2, 3, 4, 5, 6, 7]) {
                    let value = $0.as(Int.self)!
                    //AxisGridLine(stroke: StrokeStyle(lineWidth: 1, dash: [7]))
                    //AxisTick(length: 15, stroke: StrokeStyle(lineWidth: 1, dash: [7]))
                    AxisValueLabel(anchor: .topLeading) {
                        Text("\(WeekdayAbbreviation(weekdayNumber: value).rawValue)")
                            .foregroundColor(.white)
                            .padding(EdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 0))
                    }
                }
            }
            .chartYAxis {
                AxisMarks(position: .leading, values: .stride(by: 0.25)) {
                    let value = $0.as(Double.self)!
                    AxisGridLine(centered: true, stroke: StrokeStyle(lineWidth: 1, dash: [7]))
                        .foregroundStyle(Color.white.opacity(0.6))
                    AxisTick(centered: true, length: 15, stroke: StrokeStyle(lineWidth: 1, dash: [7]))
                        .foregroundStyle(Color.white.opacity(0.6))
                    AxisValueLabel {
                        Text("\(Int(value*100))%").padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 10))
                    }.foregroundStyle(Color.white.opacity(0.6))
                }
                
                AxisMarks(position: .trailing, values: .stride(by: 0.25)) {
                    AxisTick(length: 15, stroke: StrokeStyle(lineWidth: 1, dash: [7]))
                        .foregroundStyle(Color.clear)
                }
            }
        }
        .frame(height: 180)
        .background(Color.black.opacity(0.8))
        .cornerRadius(20)
        .onAppear {
            print(data)
        }
    }
}

#Preview {
    VStack{
        Spacer()
        
        Graph(color: .blue, data: [0.2, 0.6, 0.4, 0.8, 0.9, 1, 0.2])
            .padding()
        
        Spacer()
    }
    .background(Color.blue)
}


enum WeekdayAbbreviation: String {
    case mon = "Lun"
    case tue = "Mar"
    case wed = "Mer"
    case thu = "Gio"
    case fri = "Ven"
    case sat = "Sab"
    case sun = "Dom"
    case none = ""
    
    init(weekdayNumber: Int) {
        
        switch weekdayNumber {
        case 0: self = .mon
        case 1: self = .tue
        case 2: self = .wed
        case 3: self = .thu
        case 4: self = .fri
        case 5: self = .sat
        case 6: self = .sun
        default: self = .none
        }
    }
}
