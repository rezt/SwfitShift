//
//  MainView.swift
//  Shift
//
//  Created by Piotr Ćwiertnia on 13/10/2021.
//

import SwiftUI

struct MainView: View {
     
    @ObservedObject var auth: LoginViewModel
    @StateObject var calendarViewModel = CalendarViewModel()
    @StateObject var taskViewModel = TaskListViewModel()
    @StateObject var mainViewModel = MainViewModel()
    
    var body: some View {
            ZStack{
                Color(.black).ignoresSafeArea()
                NavigationLink(destination: TaskView(taskListViewModel: taskViewModel, loginViewModel: auth), isActive: $taskViewModel.showTask) {}
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 20) {
                        // Calendar View
                        CalendarView(calendarViewModel: calendarViewModel)
                        Color.gray.frame(height:CGFloat(1) / UIScreen.main.scale)
                        TaskListView(taskListViewModel: taskViewModel)
                        Color.gray.frame(height:CGFloat(1) / UIScreen.main.scale)
                    }
                }
            }.navigationBarHidden(true)
            .onAppear() {
                calendarViewModel.setAuth(with: auth)
                calendarViewModel.loadShifts()
                taskViewModel.setAuth(with: auth)
                taskViewModel.loadTasks()
            }
    }
}

struct MainView_Previews: PreviewProvider {
    @StateObject var auth = LoginViewModel()
    @StateObject var calendarViewModel = CalendarViewModel()
    @StateObject var taskViewModel = TaskListViewModel()
    static var previews: some View {
        let test = MainView_Previews()
        MainView(auth: test.auth, calendarViewModel: test.calendarViewModel, taskViewModel: test.taskViewModel)
    }
}
