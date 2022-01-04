//
//  MainView.swift
//  Shift
//
//  Created by Piotr Ćwiertnia on 13/10/2021.
//

import SwiftUI

struct MainView: View {
     
    @State var currentUser: User
    @StateObject var mainViewModel = MainViewModel()
    @StateObject var calendarViewModel = CalendarViewModel()
    @StateObject var taskListViewModel = TaskListViewModel()
    @StateObject var dispositionViewModel = DispositionViewModel()
    @StateObject var userListViewModel = UserListViewModel()
    
    init(_ user: User) {
        print(user)
        currentUser = user
    }
    
    var body: some View {
            ZStack{
                Color(.black).ignoresSafeArea()
                NavigationLink(destination: TaskView(taskViewModel: taskListViewModel.taskViewModel, taskListViewModel: taskListViewModel), isActive: $taskListViewModel.showTask) {}
                NavigationLink(destination: ShiftView(currentUser, shiftViewModel: calendarViewModel.shiftViewModel, calendarViewModel: calendarViewModel), isActive: $calendarViewModel.showShift) {}
                NavigationLink(destination: DispositionView(dispositionViewModel: dispositionViewModel), isActive: $mainViewModel.goToDisposition) {}
                NavigationLink(destination: UserListView(userListViewModel: userListViewModel), isActive: $mainViewModel.goToUsers) {}
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 20) {
                        HStack {
                            Button {
                                mainViewModel.showDisposition()
                            } label: {
                                Text("Go to disposition")
                            }
                            if currentUser.role == K.FStore.Employees.roles[0] || currentUser.role == K.FStore.Employees.roles[1] {
                                Button {
                                    mainViewModel.showUserManagement()
                                } label: {
                                    Text("Users management")
                                }
                            }
                        }
                        CalendarView(calendarViewModel: calendarViewModel, currentUser)
                        Color.gray.frame(height:CGFloat(1) / UIScreen.main.scale)
                        TaskListView(taskListViewModel: taskListViewModel)
                        Color.gray.frame(height:CGFloat(1) / UIScreen.main.scale)
                    }
                }
            }.navigationBarHidden(true)
            .onAppear() {
                print("onappear: \(currentUser)")
                calendarViewModel.update(currentUser)
                calendarViewModel.loadShifts()
                taskListViewModel.update(currentUser)
                taskListViewModel.loadTasks()
                dispositionViewModel.update(currentUser)
                dispositionViewModel.loadDisposition()
                mainViewModel.loadEmployees() { result in
                    dispositionViewModel.setEmployees(result!)
                    userListViewModel.setEmployees(result!)
                    calendarViewModel.setEmployees(result!)
                }
                
            }
    }
}
