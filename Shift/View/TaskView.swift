//
//  TaskView.swift
//  Shift
//
//  Created by Piotr Ćwiertnia on 12/11/2021.
//

import Foundation
import SwiftUI

struct TaskView: View {
    
    @ObservedObject var taskViewModel: TaskViewModel
    
    init(taskViewModel: TaskViewModel){
        UITableView.appearance().backgroundColor = .clear
        self.taskViewModel = taskViewModel
    }
    
    var body: some View {
        Form {
            Section {
                Text(taskViewModel.task?.status ?? "status")
                    .foregroundColor(.black)
            } header: {
                Text("Status:")
            }
            Section {
                Text(taskViewModel.task?.description ?? "description")
                    .foregroundColor(.black)
            } header: {
                Text("Task description:")
            }
            Section {
                DatePicker(selection: .constant(taskViewModel.task?.getDeadline() ?? Date()), label: { Text("Due to:") })
                    .foregroundColor(.black)
            } header: {
                Text("Deadline:")
            }
        }.foregroundColor(.white)
            .background(.black)
        HStack(alignment: .center){
            Button {
                
            } label: {
                Text("Save changes")
            }.foregroundColor(.white)
        }
    }
}

struct TaskView_Previews: PreviewProvider {
    @StateObject var taskViewModel = TaskViewModel()
    static var previews: some View {
        let test = TaskView_Previews()
        ZStack{
            Color(.black).ignoresSafeArea()
            TaskView(taskViewModel: test.taskViewModel)
        }
    }
}
