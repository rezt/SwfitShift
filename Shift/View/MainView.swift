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
                        Color.gray.frame(height:CGFloat(1) / UIScreen.main.scale)
                        TaskListView(taskViewModel: taskViewModel)
                        Color.gray.frame(height:CGFloat(1) / UIScreen.main.scale)
                    }
                }
            }.navigationBarHidden(true)
    }
}

struct MainView_Previews: PreviewProvider {
    @StateObject var auth = LoginViewModel()
    static var previews: some View {
        let test = MainView_Previews()
        MainView().environmentObject(test.auth)
    }
}
