//
//  TaskView.swift
//  Shift
//
//  Created by Piotr Ćwiertnia on 12/11/2021.
//

import Foundation
import SwiftUI

struct TaskView: View {
    
    @ObservedObject var auth: LoginViewModel
    @ObservedObject var taskListViewModel: TaskListViewModel
    
    
    init(taskListViewModel: TaskListViewModel, loginViewModel: LoginViewModel){
        UITableView.appearance().backgroundColor = .clear
        self.taskListViewModel = taskListViewModel
        self.auth = loginViewModel
    }
    
    var body: some View {
        VStack{
            Form {
                Section {
                    Text("📌 Title: \(taskListViewModel.taskViewModel.task?.title ?? "title")")
                        .foregroundColor(.black)
                    Text("🏆 Team: \(taskListViewModel.taskViewModel.task?.team ?? "team")")
                        .foregroundColor(.black)
                    Text("⚫️ Status: \(taskListViewModel.taskViewModel.task?.status ?? "status")")
                        .foregroundColor(.black)
                    Text("📋 Description: \(taskListViewModel.taskViewModel.task?.description ?? "description")")
                        .foregroundColor(.black)
                    DatePicker(selection: .constant(taskListViewModel.taskViewModel.task?.getDeadline() ?? Date()), label: { Text("🗓 Due to:") })
                        .foregroundColor(.black)
                } header: {
                    Text("Task info")
                }
                Section {
                    Button {
                        
                    } label: {
                        Text("❌ Delete task")
                            .foregroundColor(.black)
                    }
                    Button {
                        
                    } label: {
                        Text("💾 Save changes")
                            .foregroundColor(.black)
                    }
                    

                } header: {
                    Text("Actions")
                }
            }.foregroundColor(.white)
                .background(.black)
                .onAppear {
                    if auth.user.role == K.FStore.Employees.roles[0] || auth.user.role == K.FStore.Employees.roles[1] {
                        taskListViewModel.taskViewModel.canEdit = true
                    }
                }
        }
    }
}

struct TaskView_Previews: PreviewProvider {
    @StateObject var taskViewModel = TaskListViewModel()
    @StateObject var loginViewModel = LoginViewModel()
    static var previews: some View {
        let test = TaskView_Previews()
        ZStack{
            Color(.black).ignoresSafeArea()
            TaskView(taskListViewModel: test.taskViewModel, loginViewModel: test.loginViewModel)
        }
    }
}
