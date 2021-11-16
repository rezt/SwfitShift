//
//  MainView.swift
//  Shift
//
//  Created by Piotr Ćwiertnia on 13/10/2021.
//

import SwiftUI

struct MainView: View {
    
    @EnvironmentObject var auth: LoginViewModel
    @StateObject var calendarViewModel = CalendarViewModel()
    @StateObject var taskViewModel = TaskViewModel()
    
    var body: some View {
            ZStack{
                Color(.black).ignoresSafeArea()
                NavigationLink(destination: TaskView(taskViewModel: taskViewModel), isActive: $taskViewModel.editTask) {}
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 20) {
                        // Calendar View
                        CalendarView(/*userID: userID, */calendarViewModel: calendarViewModel).environmentObject(auth)
                        Spacer()
                        TaskListView(taskViewModel: taskViewModel)
                    }
                }
            }.navigationBarHidden(true)
    }
}

struct MainView_Previews: PreviewProvider {
    @StateObject var taskViewModel = TaskViewModel()
    static var previews: some View {
        MainView()
    }
}
