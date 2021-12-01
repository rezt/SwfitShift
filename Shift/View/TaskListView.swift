//
//  TaskListView.swift
//  Shift
//
//  Created by Piotr Ćwiertnia on 04/11/2021.
//

import SwiftUI

struct TaskListView: View {
    
    @ObservedObject var taskListViewModel: TaskListViewModel
    @State var showFinished: Bool = false
    
    var body: some View {
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
        if !self.$taskListViewModel.showFinished.wrappedValue {
            Button(action: {showFinished = true
                taskListViewModel.getFinishedTasks()
            }) {
                Text("Show finished tasks")
            }
        } else {
            Button(action: {showFinished = false
                taskListViewModel.getCurrentTasks()
            }) {
                Text("Show current tasks")
            }
        }
        Button(action: {taskListViewModel.enterNew()}) {
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
