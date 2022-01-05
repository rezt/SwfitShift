//
//  TaskListView.swift
//  Shift
//
//  Created by Piotr Ćwiertnia on 04/11/2021.
//

import SwiftUI

struct TaskListView: View {
    
    @ObservedObject var taskListViewModel: TaskListViewModel
    
    var body: some View {
            Button {
                if !taskListViewModel.showTasks {
                    taskListViewModel.getCurrentTasks()
                    taskListViewModel.showTasks = !taskListViewModel.showTasks
                } else {
                    taskListViewModel.hideTasks()
                }
                
            } label: {
                Text("Show/Hide tasks")
            }
        VStack(alignment: .leading){
                ForEach(taskListViewModel.displayedTasks, id: \.self) { task in
                    Text(task.title)
                        .foregroundColor(.white)
                        .contextMenu {
                            Text("Deadline: \(task.getDeadline())")
                            Text("Status: \(task.status)")
                        }
                        .padding()
                        .font(.title3.bold())
                        .onTapGesture {
                            taskListViewModel.enter(task: task)
                        }
                }
        }.padding()
        if self.$taskListViewModel.showTasks.wrappedValue {
            if !self.$taskListViewModel.showFinished.wrappedValue {
                Button(action: {taskListViewModel.getFinishedTasks()
                }) {
                    Text("Show finished tasks")
                }
            } else {
                Button(action: {taskListViewModel.getCurrentTasks()
                }) {
                    Text("Show current tasks")
                }
            }
        }
        Button(action: {taskListViewModel.enterNew(userRole: UserService.shared.currentUser.role)}) {
            Text("Add new task")
        }
    }
}
