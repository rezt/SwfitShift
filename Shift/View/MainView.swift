//
//  MainView.swift
//  Shift
//
//  Created by Piotr Ćwiertnia on 13/10/2021.
//

import SwiftUI

struct MainView: View {
    
    private var calendarViewModel = CalendarViewModel()
    
    var body: some View {
//        CalendarView(interval: .init()) { _ in
//                    Text("1")
//                        .padding(8)
//                        .background(Color.blue)
//                        .cornerRadius(8)
//                }
        NavigationView {
            Button(action: {self.calendarViewModel.printShifts()}) {
                Text("Button")
            }

        }.onAppear() {
            self.calendarViewModel.loadShifts()
            
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
