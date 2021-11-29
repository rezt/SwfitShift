//
//  LoginViewModel.swift
//  Shift
//
//  Created by Piotr Ćwiertnia on 17/10/2021.
//

import Foundation
import Firebase


class LoginViewModel: ObservableObject {
    @Published var isLoggedIn: Bool = false
    @Published var user = User(login: "", name: "", role: "", uid: "")
    let db = Firestore.firestore()
    let task = DispatchGroup()
    
    
    func login(withEmail email: String, withPassword password: String) {
        Auth.auth().signIn(withEmail: email, password: password) {authResult, error in
            if let e = error {
                print(e.localizedDescription)
            } else {
                self.user = User(login: "", name: "", role: "", uid: Auth.auth().currentUser!.uid)
                self.task.enter()
                self.getDetails(forUserID: self.user.uid)
                self.task.notify(queue: .main)
                {
                    self.isLoggedIn = true
                }
            }
        }
    }
    
    func getDetails(forUserID userID: String) {
        let docRef = db.collection(K.FStore.Employees.collection).whereField(K.FStore.Employees.uid, isEqualTo: userID)
        
        docRef.getDocuments() { (querySnapshot, error) in
            if let error = error {
                print("Document does not exist \(error.localizedDescription)")
            } else {
                for document in querySnapshot!.documents {
                    let data = document.data()
                    if let login = data[K.FStore.Employees.login] as? String,
                       let name = data[K.FStore.Employees.name] as? String,
                       let role = data[K.FStore.Employees.role] as? String,
                       let uid = data[K.FStore.Employees.uid] as? String {
                        self.user = User(login: login, name: name, role: role, uid: uid)
                        self.task.leave()
                    }
                }
            }
            
        }
    }
}
