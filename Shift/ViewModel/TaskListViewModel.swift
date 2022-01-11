//
//  TaskListViewModel.swift
//  Shift
//
//  Created by Piotr Ćwiertnia on 12/11/2021.
//

import Foundation
import Firebase
import SwiftUI
import FirebaseFirestore

final class TaskListViewModel: ObservableObject {
    
    var taskViewModel = TaskViewModel(withTask: Task(deadline: Timestamp(date: Date()), description: "", status: "", team: "", title: "", FSID: ""), canEdit: false)
    @Published var tasks: [Task] = []
    @Published var displayedTasks: [Task] = []
    @Published var showTask: Bool = false
    @Published var showFinished: Bool = true
    @Published var showTasks: Bool = false
    
    
    func saveTask(_ newTask: Task) {
        WebService.shared.saveTask(newTask)
    }
    
    func deleteTask(_ task: Task) {
        WebService.shared.deleteTask(task)
    }
    
    func loadTasks() {
        WebService.shared.loadTasks(role: UserService.shared.currentUser.role) { result in
            self.tasks = result!
        }
    }
    
    func detachTasks() {
        WebService.shared.detachListener(WebService.shared.tasksListener)
    }
    
    func getCurrentTasks() {
        displayedTasks.removeAll()
        for task in tasks {
            if task.status != K.FStore.Tasks.states[2] {
                displayedTasks.append(task)
            }
        }
        showFinished = false
    }
    func hideTasks() {
        displayedTasks.removeAll()
        showTasks = false
    }
    
    func getFinishedTasks() {
        displayedTasks.removeAll()
        for task in tasks {
            if task.status == K.FStore.Tasks.states[2] {
                displayedTasks.append(task)
            }
        }
        showFinished = true
    }
    
    func enter(task: Task) {
        var canEdit = false
        if UserService.shared.currentUser.role == K.FStore.Employees.roles[0] || UserService.shared.currentUser.role == K.FStore.Employees.roles[1] {
            canEdit = true
        }
        self.taskViewModel = TaskViewModel(withTask: task, canEdit: canEdit)
        showTask = true
    }
    
    func enterNew(userRole role: String) {
        self.taskViewModel = TaskViewModel(withTask: Task(deadline: Timestamp(date: Date()), description: "", status: "", team: role, title: "", FSID: ""), canEdit: true)
        showTask = true
    }
    
    func printTasks() {
        print(tasks.count)
        print(tasks)
    }
}
