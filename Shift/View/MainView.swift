//
//  MainView.swift
//  Shift
//
//  Created by Piotr Ćwiertnia on 13/10/2021.
//

import SwiftUI

struct MainView: View {
    
    @Binding var userID: String
    @StateObject var calendarViewModel = CalendarViewModel()
    @StateObject var taskViewModel = TaskViewModel()
    
    var body: some View {
        
        ZStack{
            Color(.black).ignoresSafeArea()
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 20) {
                    // Calendar View
                    CalendarView(userID: userID, calendarViewModel: calendarViewModel)
                    Spacer()
                    TaskListView(taskViewModel: taskViewModel)
                }
            }
        }.navigationBarHidden(true)
        
    }
}

struct MainView_Previews: PreviewProvider {
    @State var userID = "2zJYeIs23RG9ErizhlFY"
    @StateObject var taskViewModel = TaskViewModel()
    static var previews: some View {
        let test = MainView_Previews()
        MainView(userID: test.$userID)
    }
}
