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
        VStack(alignment: .leading){
            ForEach(taskListViewModel.tasks, id: \.self) { task in
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
        }
        if !self.$taskListViewModel.showFinished.wrappedValue {
            Button(action: {taskListViewModel.loadFinishedTasks()}) {
                Text("Show finished tasks")
            }
        } else {
            Button(action: {taskListViewModel.loadTasks()}) {
                Text("Show current tasks")
            }
        }
        Button(action: {taskListViewModel.loadFinishedTasks()}) {
            Text("Add new task")
        }
    }
}

struct TaskListView_Previews: PreviewProvider {
    @StateObject var taskListViewModel = TaskListViewModel()
    static var previews: some View {
        let test = TaskListView_Previews()
        ZStack{
            Color(.black).ignoresSafeArea()
            TaskListView(taskListViewModel: test.taskListViewModel)
        }
    }
}
