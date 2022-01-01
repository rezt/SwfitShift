//
//  CalendarView.swift
//  Shift
//
//  Created by Piotr Ćwiertnia on 18/10/2021.
//

import SwiftUI

struct CalendarView: View {
    
    var currentUser: User
    @ObservedObject var calendarViewModel: CalendarViewModel
    @State var haveShift: Bool = true
    
    init(calendarViewModel: CalendarViewModel, _ user: User) {
        self.calendarViewModel = calendarViewModel
        self.currentUser = user
    }
    
    var drag: some Gesture {
        DragGesture(minimumDistance: 30, coordinateSpace: .local)
            .onEnded({gesture in
                if gesture.startLocation.x < CGFloat(200.0) {
                    withAnimation {
                        calendarViewModel.currentMonth -= 1
                    }
                } else if (UIScreen.main.bounds.maxX - gesture.startLocation.x) < (UIScreen.main.bounds.maxX - CGFloat(200.0)) {
                    withAnimation {
                        calendarViewModel.currentMonth += 1
                    }
                }
            }
            )
    }
    
    var body: some View {
        VStack(spacing: 35) {
            
            HStack(spacing: 20) {
                VStack(alignment: .center, spacing: 10) {
                    Text(calendarViewModel.getYearMonth()[0])
                        .font(.caption)
                        .fontWeight(.heavy)
                        .foregroundColor(.white)
                    
                    Text(calendarViewModel.getYearMonth()[1])
                        .font(.largeTitle.bold())
                        .foregroundColor(.white)
                }
                
                
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
                ForEach(calendarViewModel.getDate()) { value in
                    CardView(value: value)
                        .onTapGesture {
                            calendarViewModel.currentDate = value.date
                            print(value.date)
                        }
                }
            }
            .onChange(of: calendarViewModel.currentMonth, perform: { newValue in
                // Update month
                calendarViewModel.currentDate = calendarViewModel.getCurrentMonth()
            })
            
            
            HStack(spacing: 20) {
                Button {
                    withAnimation{
                        calendarViewModel.currentMonth -= 1
                    }
                } label: {
                    Image(systemName: K.calendar.buttonPrevious)
                        .font(.title3)
                        .foregroundColor(.white)
                }
                Color.gray.frame(width:CGFloat(2) / UIScreen.main.scale)
                Button {
                    withAnimation{
                        calendarViewModel.currentMonth += 1
                    }
                } label: {
                    Image(systemName: K.calendar.buttonNext)
                        .font(.title3)
                        .foregroundColor(.white)
                }
            }
            
            VStack{
                Color.gray.frame(height:CGFloat(1) / UIScreen.main.scale)
            }
            
            ForEach(calendarViewModel.shifts, id: \.self) {shift in
                if calendarViewModel.isSameDay(date1: shift.getStartDate(), date2: calendarViewModel.currentDate) {
                    ShiftView(value: shift)
                }
            }
            
            if currentUser.role == K.FStore.Employees.roles[0] || currentUser.role == K.FStore.Employees.roles[1] {
                Button(action: {calendarViewModel.enterNew(userRole: currentUser.role)}) {
                    Text("Add shift")
                }
            }
        }
        .gesture(drag)
    }
    
    @ViewBuilder
    func ShiftView(value: Shift?) -> some View {
        withAnimation {
            VStack(spacing: 15) {
                Text("Scheduled for \(calendarViewModel.getDay()[0]), \(calendarViewModel.getDay()[1]) \(calendarViewModel.getDay()[2]), \(calendarViewModel.getDay()[3]):")
                    .font(.title3.bold())
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundColor(.white)
                
                if let shift = value {
                    Text("\nWork as: \(shift.role)\nFrom: \(shift.getStartDateTime()[0]):\(shift.getStartDateTime()[1])\nTo: \(shift.getEndDateTime()[0]):\(shift.getEndDateTime()[1])")
                        .font(.title3.bold())
                        .foregroundColor(.white)
                    if shift.employee != currentUser.uid {
                        Button(action: {calendarViewModel.takeShift(shift)}) {
                            Text("Take the shift")
                        }
                    } else {
                        Button(action: {calendarViewModel.changeStateOfShift(shift)}) {
                            Text("Up for grabs")
                        }
                    }
                    if currentUser.role == K.FStore.Employees.roles[0] || currentUser.role == K.FStore.Employees.roles[1] {
                        Button(action: {calendarViewModel.enter(shift: shift)}) {
                            Text("Edit shift")
                        }
                    }
                } else {
                    Text("No work today!")
                        .font(.title3.bold())
                        .foregroundColor(.white)
                }
        }
    }
    }
    
    @ViewBuilder
    func CardView(value: DateValue) -> some View {
        withAnimation {
            VStack {
                if value.day != -1 {
                    
                    if calendarViewModel.isSameDay(date1: calendarViewModel.currentDate, date2: value.date) {
                        ZStack {
                            Circle().foregroundColor(Color.yellow)
                            Text("\(value.day)")
                                .font(.title3.bold())
                                .foregroundColor(.white)
                        }
                    } else {
                        if let shift = calendarViewModel.shifts.first(where: { shift in
                            return calendarViewModel.isSameDay(date1: shift.getStartDate(), date2: value.date)
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
            }
            .padding(.vertical, 8)
            .frame(height: 60, alignment: .top)
        }
        
//        .transition(AnyTransition.opacity.combined(with: .move(edge: .leading)))
    }
}

