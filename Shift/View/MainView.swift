//
//  MainView.swift
//  Shift
//
//  Created by Piotr Ćwiertnia on 13/10/2021.
//

import SwiftUI

struct MainView: View {
     
    @StateObject var mainViewModel = MainViewModel()
    @StateObject var calendarViewModel = CalendarViewModel()
    @StateObject var taskListViewModel = TaskListViewModel()
    
    var body: some View {
            ZStack{
                Color(.black).ignoresSafeArea()
                NavigationLink(destination: TaskView(taskViewModel: taskListViewModel.taskViewModel, taskListViewModel: taskListViewModel), isActive: $taskListViewModel.showTask) {}
                NavigationLink(destination: ShiftView(shiftViewModel: calendarViewModel.shiftViewModel, calendarViewModel: calendarViewModel), isActive: $calendarViewModel.showShift) {}
                NavigationLink(destination: DispositionView(), isActive: $mainViewModel.goToDisposition) {}
                NavigationLink(destination: UserListView(), isActive: $mainViewModel.goToUsers) {}
                NavigationLink(destination: PresetView(), isActive: $mainViewModel.goToPresets) {}
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 20) {
                        HStack {
                            Button {
                                mainViewModel.showDisposition()
                            } label: {
                                Text("Go to disposition")
                            }
                            if UserService.shared.currentUser.role == K.FStore.Employees.roles[0] || UserService.shared.currentUser.role == K.FStore.Employees.roles[1] {
                                Button {
                                    mainViewModel.showUserManagement()
                                } label: {
                                    Text("Users...")
                                }
                                Button {
                                    mainViewModel.showPresets()
                                } label: {
                                    Text("Presets...")
                                }
                            }
                        }
                        CalendarView(calendarViewModel: calendarViewModel)
                        Color.gray.frame(height:CGFloat(1) / UIScreen.main.scale)
                        TaskListView(taskListViewModel: taskListViewModel)
                        Color.gray.frame(height:CGFloat(1) / UIScreen.main.scale)
                    }
                }
            }.navigationBarHidden(true)
            .onAppear() {
                calendarViewModel.loadShifts()
                taskListViewModel.loadTasks()
            }
            .onDisappear {
                calendarViewModel.detachShifts()
                taskListViewModel.detachTasks()
            }
    }
}
