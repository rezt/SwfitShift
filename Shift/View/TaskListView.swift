//
//  TaskListView.swift
//  Shift
//
//  Created by Piotr Ćwiertnia on 04/11/2021.
//

import SwiftUI

struct TaskListView: View {
    
    @StateObject var taskViewModel: TaskViewModel
    
    var body: some View {
            VStack{
                ForEach(taskViewModel.tasks, id: \.self) { task in
                    Text(task.description)
                        .foregroundColor(.white)
                        .contextMenu {
                            Text("Deadline: \(task.getDeadline())")
                            Text("Status: \(task.status)")
                        }
                }
            }
            Button(action: {taskViewModel.printTasks()}) {
                Text("print Tasks")
                
            }
    }
}

struct TaskListView_Previews: PreviewProvider {
    @StateObject var taskViewModel = TaskViewModel()
    static var previews: some View {
        let test = TaskListView_Previews()
        ZStack{
            Color(.black).ignoresSafeArea()
            TaskListView(taskViewModel: test.taskViewModel)
        }
    }
}
