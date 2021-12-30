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
    @Published var user = User(login: "", name: "", role: "", uid: "", FSID: "")
    @Published var employees = [User]()
    let db = Firestore.firestore()
    let task = DispatchGroup()
    let task2 = DispatchGroup()
    
    typealias GetDetailsClosure = (Array<User>?) -> Void
    
    func login(withEmail email: String, withPassword password: String) {
        Auth.auth().signIn(withEmail: email, password: password) {authResult, error in
            if let e = error {
                print(e.localizedDescription)
            } else {
                self.user = User(login: "", name: "", role: "", uid: Auth.auth().currentUser!.uid, FSID: "")
                self.getDetails(forUserID: self.user.uid) { result in
                    if result != nil {
                        self.user = result![0]
                        self.employees.append(self.user)
                        self.isLoggedIn = true
                    } else {
                        do { try Auth.auth().signOut() }
                        catch { print("Already logged out") }
                    }
                }
            }
        }
    }
    
    
    func getDetails(forUserID userID: String, completionHandler: @escaping GetDetailsClosure) {
        let docRef = db.collection(K.FStore.Employees.collection).whereField(K.FStore.Employees.uid, isEqualTo: userID)
        
        var result = [User]()
        
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
                        result.append(User(login: login, name: name, role: role, uid: uid, FSID: document.documentID))
                        DispatchQueue.main.async {
                            if result.isEmpty {
                                completionHandler(nil)
                            } else {
                                completionHandler(result)
                            }
                        }
                    }
                }
            }
            
        }
    }
    
    func loadEmployees() {
        db.collection(K.FStore.Employees.collection).addSnapshotListener { (querySnapshot, error) in
            self.employees = []
            
            if let e = error {
                print("There was an issue retriving shift data from Firestore. \(e)")
            } else {
                if let snapshotDocuments = querySnapshot?.documents {
                    for doc in snapshotDocuments {
                        print("getting employee")
                        let data = doc.data()
                        if let login = data[K.FStore.Employees.login] as? String,
                           let name = data[K.FStore.Employees.name] as? String,
                           let role = data[K.FStore.Employees.role] as? String,
                           let uid = data[K.FStore.Employees.uid] as? String {
                            let nextEmployee = User(login: login, name: name, role: role, uid: uid, FSID: doc.documentID)
                            self.employees.append(nextEmployee)
                        }
                    }
                }
            }
        }
    }
    
    func disable(user: User) {
        db.collection(K.FStore.Employees.collection).document(user.FSID).delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
            }
        }
    }
    
    func saveUser(_ newUser: User, selectedRole: String) {
        
        db.collection(K.FStore.Employees.collection).document(newUser.FSID).setData([
            K.FStore.Employees.login: newUser.login,
            K.FStore.Employees.name: newUser.name,
            K.FStore.Employees.role: selectedRole,
            K.FStore.Employees.uid: newUser.uid
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated!")
            }
        }
    }
    
    func createUser(_ newUser: User, email: String, password: String) {
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
                    if let err = error {
                        print("Error updating document: \(err)")
                    }else{
                        print("Document successfully updated!")
                        var ref: DocumentReference? = nil
                        ref = self.db.collection(K.FStore.Employees.collection).addDocument(data: [
                            K.FStore.Employees.login: newUser.login,
                            K.FStore.Employees.name: newUser.name,
                            K.FStore.Employees.role: newUser.role,
                            K.FStore.Employees.uid: result!.user.uid
                        ]) { err in
                            if let err = err {
                                print("Error adding document: \(err)")
                            } else {
                                print("User added with ID: \(ref!.documentID)")
                            }
                        }
                    }
                 }
    }
    
    func loadEmployees(withRole role: String) {
        db.collection(K.FStore.Employees.collection).whereField(K.FStore.Employees.role, isEqualTo: role).addSnapshotListener { (querySnapshot, error) in
            self.employees = []
            
            if let e = error {
                print("There was an issue retriving shift data from Firestore. \(e)")
            } else {
                if let snapshotDocuments = querySnapshot?.documents {
                    for doc in snapshotDocuments {
                        print("getting employee")
                        let data = doc.data()
                        if let login = data[K.FStore.Employees.login] as? String,
                           let name = data[K.FStore.Employees.name] as? String,
                           let role = data[K.FStore.Employees.role] as? String,
                           let uid = data[K.FStore.Employees.uid] as? String {
                            let nextEmployee = User(login: login, name: name, role: role, uid: uid, FSID: doc.documentID)
                            self.employees.append(nextEmployee)
                        }
                    }
                }
            }
        }
    }
    
    func loadAllUsers() {
        db.collection(K.FStore.Employees.collection).addSnapshotListener { (querySnapshot, error) in
            self.employees = []
        }
    }
    
    func printEmployees() {
        print(self.employees.count)
    }
    
    
}
