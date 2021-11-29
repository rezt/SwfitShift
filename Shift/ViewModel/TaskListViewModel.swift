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
    
    let db = Firestore.firestore()
    @ObservedObject var auth: LoginViewModel
    @Published var tasks: [Task] = []
    @Published var showTask: Bool = false
    @StateObject var taskViewModel = TaskViewModel()
    @Published var showFinished: Bool = false
    
    init() {
        auth = LoginViewModel()
    }
    
    func setAuth(with auth: LoginViewModel) {
        print(auth.user.role)
        self.auth = auth
    }
    
    func loadFinishedTasks() {
        db.collection(K.FStore.Tasks.collection).whereField(K.FStore.Tasks.status, isEqualTo: K.FStore.Tasks.states[2]) // != "Done"
            .addSnapshotListener { (querySnapshot, error) in
            self.tasks = []
            
            if let e = error {
                print("There was an issue retriving tasks data from Firestore. \(e)")
            } else {
                if let snapshotDocuments = querySnapshot?.documents {
                    for doc in snapshotDocuments {
                        let data = doc.data()
                        if let deadline = data[K.FStore.Tasks.deadline] as? Timestamp,
                           let description = data[K.FStore.Tasks.description] as? String,
                           let status = data[K.FStore.Tasks.status] as? String,
                           let team = data[K.FStore.Tasks.team] as? String,
                           let title = data[K.FStore.Tasks.title] as? String {
                            let newTask = Task(deadline: deadline, description: description, status: status, team: team, title: title, FSID: doc.documentID)
                            self.tasks.append(newTask)
                            DispatchQueue.main.async {
                                self.printTasks()
                            }
                        }
                    }
                }
            }
        }
        showFinished = true
    }
    
    func loadTasks() {
        db.collection(K.FStore.Tasks.collection).whereField(K.FStore.Tasks.team, isEqualTo: auth.user.role)
            .addSnapshotListener { (querySnapshot, error) in
            self.tasks = []
            
            if let e = error {
                print("There was an issue retriving tasks data from Firestore. \(e)")
            } else {
                if let snapshotDocuments = querySnapshot?.documents {
                    for doc in snapshotDocuments {
                        let data = doc.data()
                        if let deadline = data[K.FStore.Tasks.deadline] as? Timestamp,
                           let description = data[K.FStore.Tasks.description] as? String,
                           let status = data[K.FStore.Tasks.status] as? String,
                           let team = data[K.FStore.Tasks.team] as? String,
                           let title = data[K.FStore.Tasks.title] as? String {
                            let newTask = Task(deadline: deadline, description: description, status: status, team: team, title: title, FSID: doc.documentID)
                            self.tasks.append(newTask)
                            DispatchQueue.main.async {
                                self.printTasks()
                            }
                        }
                    }
                }
            }
        }
        showFinished = false
    }
    
    func enter(task: Task) {
        self.taskViewModel.task = task
        showTask = true
    }
    
    func enterNew() {
        self.taskViewModel.task = Task(deadline: Timestamp(date: Date()), description: "", status: "", team: "", title: "", FSID: "")
        showTask = true
    }
    
    func printTasks() {
        print(tasks.count)
        print(tasks)
    }
}
