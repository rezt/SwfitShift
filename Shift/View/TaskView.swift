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
    
    @ObservedObject var taskViewModel: TaskViewModel
    @ObservedObject var taskListViewModel: TaskListViewModel
    @State var titleField: String = "title"
    @State var statusField: String = "status"
    @State var descriptionField: String = "description"
    @State var selectedTeam: String = "test"
    @State var selectedTeamName: String = ""
    @State var deadline: Date = Date()
    @State var alreadySeen: Bool = false
    @Environment(\.presentationMode) var presentationMode
    
    init(taskViewModel: TaskViewModel, taskListViewModel: TaskListViewModel){
        UITableView.appearance().backgroundColor = .clear
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
                        Picker(selection: $selectedTeam, label: Text("🏆 Team:").foregroundColor(.black)) {
                            ForEach(K.FStore.Employees.roles, id: \.self) { role in
                                Text(role).foregroundColor(.black).tag(role)
                                }
                            }
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
                    Text("🏆 Team: \(selectedTeamName)")
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
                                taskViewModel.task = Task(deadline: Timestamp(date:deadline), description: descriptionField, status: statusField, team: selectedTeam, title: titleField, FSID: taskViewModel.task!.FSID)
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
                        if taskViewModel.task?.FSID != "" {
                            Button {
                                taskListViewModel.deleteTask(taskViewModel.task!)
                                presentationMode.wrappedValue.dismiss()
                            } label: {
                                Text("❌ Delete task")
                                    .foregroundColor(.black)
                            }
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
                    if !alreadySeen {
                        titleField = taskViewModel.task!.title
                        statusField = taskViewModel.task!.status
                        descriptionField = taskViewModel.task!.description
                        deadline = taskViewModel.task!.deadline.dateValue()
                        selectedTeamName = taskViewModel.task!.team
                    }
                    alreadySeen = true
                }
        }
    }
}
