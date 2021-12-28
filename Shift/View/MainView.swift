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
    @StateObject var taskListViewModel = TaskListViewModel()
    @StateObject var dispositionViewModel = DispositionViewModel()
    @StateObject var mainViewModel = MainViewModel()
    @StateObject var userListViewModel = UserListViewModel()
    
    var body: some View {
            ZStack{
                Color(.black).ignoresSafeArea()
                NavigationLink(destination: TaskView(taskViewModel: taskListViewModel.taskViewModel, taskListViewModel: taskListViewModel, loginViewModel: auth), isActive: $taskListViewModel.showTask) {}
                NavigationLink(destination: ShiftView(shiftViewModel: calendarViewModel.shiftViewModel, calendarViewModel: calendarViewModel, loginViewModel: auth), isActive: $calendarViewModel.showShift) {}
                NavigationLink(destination: DispositionView(dispositionViewModel: dispositionViewModel, loginViewModel: auth), isActive: $mainViewModel.goToDisposition) {}
                NavigationLink(destination: UserListView(userListViewModel: userListViewModel, loginViewModel: auth), isActive: $mainViewModel.goToUsers) {}
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 20) {
                        HStack {
                            Button {
                                mainViewModel.showDisposition()
                            } label: {
                                Text("Go to disposition")
                            }
                            if auth.user.role == K.FStore.Employees.roles[0] || auth.user.role == K.FStore.Employees.roles[1] {
                                Button {
                                    mainViewModel.showUserManagement()
                                } label: {
                                    Text("Users management")
                                }
                            }
                        }
                        CalendarView(calendarViewModel: calendarViewModel, auth: auth)
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
                dispositionViewModel.setAuth(with: auth)
                dispositionViewModel.loadDisposition()
                
                auth.loadEmployees()
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
