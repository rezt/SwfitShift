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
    @Published var displayedTasks: [Task] = []
    @Published var showTask: Bool = false
    var taskViewModel = TaskViewModel(withTask: Task(deadline: Timestamp(date: Date()), description: "", status: "", team: "", title: "", FSID: ""), canEdit: false)
    @Published var showFinished: Bool = true
    
    init() {
        auth = LoginViewModel()
    }
    
    func setAuth(with auth: LoginViewModel) {
        print(auth.user.role)
        self.auth = auth
    }
    
    func saveTask(_ newTask: Task) {
        if newTask.FSID == "" {
            var ref: DocumentReference? = nil
            ref = db.collection(K.FStore.Tasks.collection).addDocument(data: [
                K.FStore.Tasks.title: newTask.title,
                K.FStore.Tasks.status: newTask.status,
                K.FStore.Tasks.team: newTask.team,
                K.FStore.Tasks.description: newTask.description,
                K.FStore.Tasks.deadline: newTask.deadline
            ]) { err in
                if let err = err {
                    print("Error adding document: \(err)")
                } else {
                    print("Document added with ID: \(ref!.documentID)")
                }
            }
        } else {
            db.collection(K.FStore.Tasks.collection).document(newTask.FSID).setData([
                K.FStore.Tasks.title: newTask.title,
                K.FStore.Tasks.status: newTask.status,
                K.FStore.Tasks.team: newTask.team,
                K.FStore.Tasks.description: newTask.description,
                K.FStore.Tasks.deadline: newTask.deadline
            ]) { err in
                if let err = err {
                    print("Error updating document: \(err)")
                } else {
                    print("Document successfully updated!")
                }
            }
            
        }
    }
    
    func deleteTask(_ task: Task) {
        db.collection(K.FStore.Tasks.collection).document(task.FSID).delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
            }
        }
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
                            }
                        }
                    }
                }
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
        if auth.user.role == K.FStore.Employees.roles[0] || auth.user.role == K.FStore.Employees.roles[1] {
            canEdit = true
            print("canedit")
        }
        self.taskViewModel = TaskViewModel(withTask: task, canEdit: canEdit)
        showTask = true
    }
    
    func enterNew() {
        self.taskViewModel = TaskViewModel(withTask: Task(deadline: Timestamp(date: Date()), description: "", status: "", team: "", title: "", FSID: ""), canEdit: true)
        showTask = true
    }
    
    func printTasks() {
        print(tasks.count)
        print(tasks)
    }
}
