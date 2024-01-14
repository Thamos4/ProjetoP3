//
//  ConferenceDaysView.swift
//  ProjetoP3
//
//  Created by Catarina Vasconcelos on 12/01/2024.
//

import SwiftUI

struct ConferenceDaysView: View {
    let beginDate: String
    let endDate: String
    
    @Binding var currentDay: Date
    @State private var conferenceDays: [Date] = []
    @Namespace var animation
    
    func isToday(date: Date) -> Bool {
        let calendar = Calendar.current
        
        return calendar.isDate(currentDay, inSameDayAs: date)
    }

    func extractDate(date: Date, format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        
        return formatter.string(from: date)
    }

    func datesInRange(startDate: String, endDate: String) -> [Date] {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"

        guard let startDate = dateFormatter.date(from: startDate),
              let endDate = dateFormatter.date(from: endDate) else {
            return []
        }

        var dates: [Date] = []
        var currentDate = startDate

        while currentDate <= endDate {
            dates.append(currentDate)
            currentDate = Calendar.current.date(byAdding: .day, value: 1, to: currentDate)!
        }
        
        return dates
    }
        
    var body: some View {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10){
                    ForEach(conferenceDays, id: \.self){ day in
                        VStack(spacing: 10) {
                            Text(extractDate(date: day, format: "DD"))
                                .font(.system(size: 15))
                                .fontWeight(.semibold)
                            
                            Text(extractDate(date: day, format: "MMM"))
                                .font(.system(size: 14))
                            
                            Circle()
                                .fill(.white)
                                .frame(width: 8, height: 8)
                                .opacity(isToday(date: day) ? 1 : 0)
                            
                        }
                        .foregroundStyle(isToday(date: day) ? .primary : .secondary)
                        .foregroundColor(isToday(date: day) ? .white : .black)
                        .frame(width: 45, height: 90)
                        .background(
                            ZStack{
                                if isToday(date: day) {
                                    Capsule()
                                        .fill(.black)
                                        .matchedGeometryEffect(id: "CURRENTDAY", in: animation)
                                }
                            }
                        )
                        .contentShape(Capsule())
                        .onTapGesture {
                            withAnimation {
                                currentDay = day
                            }
                        }
                    }
                    
                }.onAppear {
                    self.conferenceDays = datesInRange(startDate: beginDate, endDate: endDate)
                }
            }
        }
    }

    
struct ConferenceDaysView_Previews: PreviewProvider {
    static var previews: some View {
        let conference = Conference.MOCK_CONFERENCE
        
        ConferenceDaysView(beginDate: conference.beginDate, endDate: conference.endDate, currentDay: .constant(Date()))
            
    }
}



