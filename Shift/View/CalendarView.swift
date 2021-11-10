//
//  CalendarView.swift
//  Shift
//
//  Created by Piotr Ćwiertnia on 18/10/2021.
//

import SwiftUI

struct CalendarView: View {
    @Binding var currentDate: Date
    // Control current month by using arrows in the top right
    @State var currentMonth: Int = 0
    let userID: String
    
    @StateObject private var calendarViewModel = CalendarViewModel()
    
    var body: some View {
        VStack(spacing: 35) {
            
            HStack(spacing: 20) {
                VStack(alignment: .leading, spacing: 10) {
                    Text(getYearMonth()[0])
                        .font(.caption)
                        .fontWeight(.heavy)
                        .foregroundColor(.white)
                    
                    Text(getYearMonth()[1])
                        .font(.largeTitle.bold())
                        .foregroundColor(.white)
                }
                
                Spacer()
                
                Button {
                    withAnimation{
                        currentMonth -= 1
                    }
                } label: {
                    Image(systemName: K.calendar.buttonPrevious)
                        .font(.title3)
                        .foregroundColor(.white)
                }
                
                Button {
                    withAnimation{
                        currentMonth += 1
                    }
                } label: {
                    Image(systemName: K.calendar.buttonNext)
                        .font(.title3)
                        .foregroundColor(.white)
                }
                
            }
            .onAppear{
                calendarViewModel.loadShifts()
            }
            .padding(.horizontal)
            //Day view
            
            HStack {
                ForEach(K.calendar.days, id: \.self){ day in
                    Text(day)
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity)
                        .foregroundColor(.white)
                }
            }
            
            let columns = Array(repeating: GridItem(.flexible()), count: 7)
            
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(getDate()) { value in
                    CardView(value: value)
                        .onTapGesture {
                            currentDate = value.date
                            print(value.date)
                        }
                }
            }
            .onChange(of: currentMonth, perform: { newValue in
                // Update month
                currentDate = getCurrentMonth()
            })
            
            VStack(spacing: 15) {
                Text("Schedule:")
                    .font(.title2.bold())
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundColor(.white)
                
                if let shift = calendarViewModel.shifts.first(where: {shift in
                    return isSameDay(date1: shift.getStartDate(), date2: currentDate)
                }) {
                    Text("Work as: \(shift.role)\nFrom: \(shift.getStartDateTime()[0]):\(shift.getStartDateTime()[1])\nTo: \(shift.getEndDateTime()[0]):\(shift.getEndDateTime()[1])")
                        .font(.title3.bold())
                        .foregroundColor(.white)
                    Button(action: {calendarViewModel.changeStateOfShift(shift)}) {
                        Text("Up for grabs")
                    }
                } else {
                    Text("No work today!")
                        .font(.title3.bold())
                        .foregroundColor(.white)

                }
                
            }
            .padding()
            
            
        }
    }
    
    
    @ViewBuilder
    func CardView(value: DateValue) -> some View {
        
        VStack {
            if value.day != -1 {
                
                
                if let shift = calendarViewModel.shifts.first(where: { shift in
                    return isSameDay(date1: shift.getStartDate(), date2: value.date)
                }){
                    ZStack{
                        if shift.upForGrabs {
                            Circle().foregroundColor(Color.blue)
                        } else {
                            Circle().foregroundColor(Color.pink)
                        }
                        Text("\(value.day)")
                            .font(.title3.bold())
                            .foregroundColor(.white)
                    }
                }
                else {
                    ZStack{
                        Circle().foregroundColor(Color.gray)
                        Text("\(value.day)")
                            .font(.title3.bold())
                            .foregroundColor(.white)
                    }
                }
            }
        }
        .padding(.vertical, 8)
        .frame(height: 60, alignment: .top)
    }
    
    func isSameDay(date1: Date, date2: Date) -> Bool {
        let calendar = Calendar.current
        return calendar.isDate(date1, inSameDayAs: date2)
    }
    
    func getYearMonth() -> [String] {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY MMMM"
        let date = formatter.string(from: currentDate)
        return date.components(separatedBy: " ")
    }
    
    func getCurrentMonth() -> Date {
        let calendar = Calendar.current
    
        guard let currentMonth = calendar.date(byAdding: .month, value: self.currentMonth, to: Date()) else {
            return Date()
        }
        
        return currentMonth
    }
    
    func getDate()->[DateValue]{
        
        let calendar = Calendar.current
        
        let currentMonth = getCurrentMonth()
        
        var days = currentMonth.getAllDates().compactMap { date -> DateValue in
            let day = calendar.component(.day, from: date)
            return DateValue(day: day , date: date)
        }
        
        
        // Move sunday to be the last day of th week
        var firstWeekday = calendar.component(.weekday, from: days.first!.date)
        print(firstWeekday)
        firstWeekday -= 1
        if firstWeekday == 0 {
            firstWeekday = 7
        }
        
        // Add "empty" days to match weekday
        for _ in 0..<firstWeekday - 1 {
            days.insert(DateValue(day: -1, date: Date()), at: 0)
        }
        
        
        return days
    }
    
}

//struct CalendarView_Previews: PreviewProvider {
//    static var previews: some View {
//        CalendarView()
//    }
//}

extension Date{
    func getAllDates() -> [Date] {
        let calendar = Calendar.current

        // Get starting date
        let startDate = calendar.date(from: Calendar.current.dateComponents([.year,.month], from: self))!
        let range = calendar.range(of: .day, in: .month, for: startDate)!

        return range.compactMap{day -> Date in
            return calendar.date(byAdding: .day, value: day - 1, to: startDate)!
        }
    }
    
}

