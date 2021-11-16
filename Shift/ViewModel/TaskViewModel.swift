//
//  TaskViewModel.swift
//  Shift
//
//  Created by Piotr Ćwiertnia on 12/11/2021.
//

import Foundation
import Firebase

final class TaskViewModel: ObservableObject {
    
    let db = Firestore.firestore()
    @Published var tasks: [Task] = []
    @Published var editTask: Bool = false
    @Published var id: String = ""
    
    init() {
        loadTasks()
    }
    
    func loadTasks() {
        db.collection(K.FStore.Tasks.collection).addSnapshotListener { (querySnapshot, error) in
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
                           let team = data[K.FStore.Tasks.team] as? String {
                            let newTask = Task(deadline: deadline, description: description, status: status, team: team, FSID: doc.documentID)
                            self.tasks.append(newTask)
                            DispatchQueue.main.async {
                                self.printTasks()
                            }
                        }
                    }
                }
            }
        }
    }
    
    func enter(task: Task) {
        id = task.FSID
        editTask = true
    }
    
    func printTasks() {
        print(tasks.count)
        print(tasks)
    }
}
