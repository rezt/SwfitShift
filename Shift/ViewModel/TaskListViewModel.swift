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
    
    var currentUser = User(login: "", name: "", role: "", uid: "", FSID: "")
    @Published var tasks: [Task] = []
    @Published var displayedTasks: [Task] = []
    @Published var showTask: Bool = false
    var taskViewModel = TaskViewModel(withTask: Task(deadline: Timestamp(date: Date()), description: "", status: "", team: "", title: "", FSID: ""), canEdit: false)
    @Published var showFinished: Bool = true
    @Published var showTasks: Bool = false
    
    var webService = WebService()
    
    func update(_ user: User) {
        self.currentUser = user
    }
    
    func saveTask(_ newTask: Task) {
        webService.saveTask(newTask)
    }
    
    func deleteTask(_ task: Task) {
        webService.deleteTask(task)
    }
    
    func loadTasks() {
        webService.loadTasks(role: currentUser.role) { result in
            self.tasks = result!
        }
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
        if currentUser.role == K.FStore.Employees.roles[0] || currentUser.role == K.FStore.Employees.roles[1] {
            canEdit = true
            print("canedit")
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
