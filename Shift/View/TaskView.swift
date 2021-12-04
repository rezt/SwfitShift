//
//  TaskView.swift
//  Shift
//
//  Created by Piotr Ćwiertnia on 12/11/2021.
//

import Foundation
import SwiftUI
import Firebase

struct TaskView: View {
    
    @ObservedObject var auth: LoginViewModel
    @ObservedObject var taskViewModel: TaskViewModel
    @ObservedObject var taskListViewModel: TaskListViewModel
    @State var titleField: String = "title"
    @State var statusField: String = "status"
    @State var descriptionField: String = "description"
    @State var teamField: String = "role"
    @State var deadline: Date = Date()
    @Environment(\.presentationMode) var presentationMode
    
    init(taskViewModel: TaskViewModel, taskListViewModel: TaskListViewModel, loginViewModel: LoginViewModel){
        UITableView.appearance().backgroundColor = .clear
        self.auth = loginViewModel
        self.taskViewModel = taskViewModel
        self.taskListViewModel = taskListViewModel
    }
    
    var body: some View {
        VStack{
            Form {
                Section {
                    if self.$taskViewModel.edit.wrappedValue { // Admin view
                        Text("📌 Title:")
                            .foregroundColor(.black)
                        TextField("Title...", text: $titleField)
                            .foregroundColor(.black)
                        Text("🏆 Team:")
                            .foregroundColor(.black)
                        TextField("Team...", text: $teamField)
                            .foregroundColor(.black)
                        Text("⚫️ Status:")
                            .foregroundColor(.black)
                        TextField("Status...", text: $statusField)
                            .foregroundColor(.black)
                        Text("📋 Description:")
                            .foregroundColor(.black)
                        TextField("Description...", text: $descriptionField)
                            .foregroundColor(.black)
                        DatePicker(selection: $deadline, label: { Text("🗓 Due to:") })
                            .foregroundColor(.black)
                    } else { // User view
                    Text("📌 Title: \(taskViewModel.task?.title ?? "title")")
                        .foregroundColor(.black)
                    Text("🏆 Team: \(taskViewModel.task?.team ?? "team")")
                        .foregroundColor(.black)
                    Text("⚫️ Status: \(taskViewModel.task?.status ?? "status")")
                        .foregroundColor(.black)
                    Text("📋 Description:\n\n\(taskViewModel.task?.description ?? "description")\n")
                        .foregroundColor(.black)
                    Text("🗓 Due to:\n\n\(taskViewModel.task?.getDeadline() ?? Date())\n")
                        .foregroundColor(.black)
                    }
                } header: {
                    Text("Task info")
                }
                Section {
                    if self.$taskViewModel.canEdit.wrappedValue { // Admin view
                        if self.$taskViewModel.edit.wrappedValue {
                            Button {
                                taskViewModel.task = Task(deadline: Timestamp(date:deadline), description: descriptionField, status: statusField, team: teamField, title: titleField, FSID: taskViewModel.task!.FSID)
                                taskListViewModel.saveTask(taskViewModel.task!)
                                taskViewModel.editTask()
                            } label: {
                                Text("💾 Save changes")
                                    .foregroundColor(.black)
                            }
                        } else {
                            Button {
                                taskViewModel.editTask()
                            } label: {
                                Text("✏️ Edit task")
                                    .foregroundColor(.black)
                            }
                        }
                        Button {
                            taskListViewModel.deleteTask(taskViewModel.task!)
                            presentationMode.wrappedValue.dismiss()
                        } label: {
                            Text("❌ Delete task")
                                .foregroundColor(.black)
                        }
                    } else { // User view
                        Button {
                            
                        } label: {
                            Text("✅ Ready for the next stage")
                                .foregroundColor(.black)
                        }
                    }
                   
                    

                } header: {
                    Text("Actions")
                }
            }.foregroundColor(.white)
                .background(.black)
                .onAppear {
                    titleField = taskViewModel.task!.title
                    statusField = taskViewModel.task!.status
                    descriptionField = taskViewModel.task!.description
                    teamField = taskViewModel.task!.team
                    deadline = taskViewModel.task!.deadline.dateValue()
                }
        }
    }
}

struct TaskView_Previews: PreviewProvider {
    @StateObject var taskViewModel = TaskViewModel(withTask: Task(deadline: Timestamp(date: Date()), description: "", status: "", team: "", title: "", FSID: ""), canEdit: false)
    @StateObject var loginViewModel = LoginViewModel()
    @StateObject var taskListViewModel = TaskListViewModel()
    static var previews: some View {
        let test = TaskView_Previews()
        ZStack{
            Color(.black).ignoresSafeArea()
            TaskView(taskViewModel: test.taskViewModel, taskListViewModel: test.taskListViewModel, loginViewModel: test.loginViewModel)
        }
    }
}
