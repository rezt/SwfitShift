//
//  MainView.swift
//  Shift
//
//  Created by Piotr Ćwiertnia on 13/10/2021.
//

import SwiftUI
import UserNotifications

struct MainView: View {
     
    @ObservedObject var auth: LoginViewModel
    @StateObject var calendarViewModel = CalendarViewModel()
    @StateObject var taskListViewModel = TaskListViewModel()
    @StateObject var mainViewModel = MainViewModel()
    
    var body: some View {
            ZStack{
                Color(.black).ignoresSafeArea()
                NavigationLink(destination: TaskView(taskViewModel: taskListViewModel.taskViewModel, taskListViewModel: taskListViewModel, loginViewModel: auth), isActive: $taskListViewModel.showTask) {}
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 20) {
                        // Calendar View
                        CalendarView(calendarViewModel: calendarViewModel)
                        Color.gray.frame(height:CGFloat(1) / UIScreen.main.scale)
                        TaskListView(taskListViewModel: taskListViewModel)
                        Color.gray.frame(height:CGFloat(1) / UIScreen.main.scale)
                    }
                }
            }.navigationBarHidden(true)
            .onAppear() {
                calendarViewModel.setAuth(with: auth)
                calendarViewModel.loadShifts()
                taskListViewModel.setAuth(with: auth)
                taskListViewModel.loadTasks()
            }
    }
}

struct MainView_Previews: PreviewProvider {
    @StateObject var auth = LoginViewModel()
    @StateObject var calendarViewModel = CalendarViewModel()
    @StateObject var taskListViewModel = TaskListViewModel()
    static var previews: some View {
        let test = MainView_Previews()
        MainView(auth: test.auth, calendarViewModel: test.calendarViewModel, taskListViewModel: test.taskListViewModel)
    }
}
