//
//  WebService.swift
//  Shift
//
//  Created by Piotr Ćwiertnia on 01/01/2022.
//

import Foundation
import Firebase

class WebService {
    let db = Firestore.firestore()
    
    typealias LoginClosure = (User?) -> Void
    typealias GetDetailsClosure = (Array<User>?) -> Void
    typealias LoadEmployeesClosure = (Array<User>?) -> Void
    typealias LoadShiftsRoleClosure = (Array<Shift>?) -> Void
    typealias LoadTasksClosure = (Array<Task>?) -> Void
    typealias LoadDispositionClosure = (Array<Disposition>?) -> Void
    typealias LoadPresetsClosure = (Array<Preset>?) -> Void
    
    func login(withEmail email: String, withPassword password: String, completionHandler: @escaping LoginClosure) {
        Auth.auth().signIn(withEmail: email, password: password) {authResult, error in
            if let e = error {
                print(e.localizedDescription)
            } else {
                let user = User(login: "", name: "", role: "", uid: Auth.auth().currentUser!.uid, FSID: "")
                self.getDetails(forUserID: user.uid) { result in
                    if result != nil {
                        completionHandler(result![0])
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
    
    func loadEmployees(completionHandler: @escaping LoadEmployeesClosure) {
        db.collection(K.FStore.Employees.collection).addSnapshotListener { (querySnapshot, error) in
            var result = [User]()
            
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
                            result.append(nextEmployee)
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
    
    func disable(user: User) {
        db.collection(K.FStore.Employees.collection).document(user.FSID).delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
            }
        }
    }
    
    func modifyDisposition(newDispo: Disposition, FSID: String) {
        db.collection(K.FStore.Disposition.collection).document(FSID).setData([
            K.FStore.Disposition.date: newDispo.date,
            K.FStore.Disposition.available: newDispo.available,
            K.FStore.Disposition.notPreferred: newDispo.notPreferred,
            K.FStore.Disposition.unavailable: newDispo.unavailable,
            K.FStore.Disposition.unknown: newDispo.unknown
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated!")
            }
        }
    }
    
    func generateDisposition(lastDate: Date, uids: [String]) {
        var ref: DocumentReference? = nil
        ref = db.collection(K.FStore.Disposition.collection).addDocument(data: [
            K.FStore.Disposition.date: Timestamp(date: lastDate),
            K.FStore.Disposition.available: [""],
            K.FStore.Disposition.notPreferred: [""],
            K.FStore.Disposition.unavailable: [""],
            K.FStore.Disposition.unknown: uids
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
            }
        }
    }
    
    func loadDisposition(completionHandler: @escaping LoadDispositionClosure) { // Load only shifts specified to user or user's role
        
        let futureDate = Calendar.current.date(byAdding: .day, value: 31, to: Date())
        
        db.collection(K.FStore.Disposition.collection).whereField("date", isGreaterThanOrEqualTo: Date()).whereField("date", isLessThanOrEqualTo: futureDate!).addSnapshotListener { (querySnapshot, error) in
            var result = [Disposition]()
            
            if let e = error {
                print("There was an issue retriving shift data from Firestore. \(e)")
            } else {
                if let snapshotDocuments = querySnapshot?.documents {
                    for doc in snapshotDocuments {
                        let data = doc.data()
                        if let available = data[K.FStore.Disposition.available] as? [String],
                           let notPreferred = data[K.FStore.Disposition.notPreferred] as? [String],
                           let unavailable = data[K.FStore.Disposition.unavailable] as? [String],
                           let unknown = data[K.FStore.Disposition.unknown] as? [String],
                           let date = data[K.FStore.Disposition.date] as? Timestamp {
                            let newDisposition = Disposition(date: date, available: available, notPreferred: notPreferred, unavailable: unavailable, unknown: unknown, FSID: doc.documentID)
                            result.append(newDisposition)
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
    
    func loadPresets(completionHandler: @escaping LoadPresetsClosure) {
        db.collection(K.FStore.Presets.collection).addSnapshotListener { (querySnapshot, error) in
            var result = [Preset]()
            
            if let e = error {
                print("There was an issue retriving preset data from Firestore. \(e)")
            } else {
                if let snapshotDocuments = querySnapshot?.documents {
                    for doc in snapshotDocuments {
                        let data = doc.data()
                        if let startDate = data[K.FStore.Presets.start] as? Timestamp,
                           let endDate = data[K.FStore.Presets.end] as? Timestamp,
                           let name = data[K.FStore.Presets.name] as? String {
                            let newPreset = Preset(startDate: startDate, endDate: endDate, name: name)
                            result.append(newPreset)
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
    
    func cleanup(day: Disposition, newAvailable: [String], newNotPreferred: [String], newUnavailable: [String], newUnknown: [String]) {
        
        db.collection(K.FStore.Disposition.collection).document(day.FSID).setData([
            K.FStore.Disposition.date: day.date,
            K.FStore.Disposition.available: newAvailable,
            K.FStore.Disposition.notPreferred: newNotPreferred,
            K.FStore.Disposition.unavailable: newUnavailable,
            K.FStore.Disposition.unknown: newUnknown
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated!")
            }
        }
    }
    
    func saveShift(_ newShift: Shift) {
        if newShift.FSID == "" {
            var ref: DocumentReference? = nil
            ref = db.collection(K.FStore.Shifts.collection).addDocument(data: [
                K.FStore.Shifts.employee: newShift.employee,
                K.FStore.Shifts.role: newShift.role,
                K.FStore.Shifts.state: newShift.upForGrabs,
                K.FStore.Shifts.start: newShift.startDate,
                K.FStore.Shifts.end: newShift.endDate
            ]) { err in
                if let err = err {
                    print("Error adding document: \(err)")
                } else {
                    print("Document added with ID: \(ref!.documentID)")
                }
            }
        } else {
            db.collection(K.FStore.Shifts.collection).document(newShift.FSID).setData([
                K.FStore.Shifts.employee: newShift.employee,
                K.FStore.Shifts.role: newShift.role,
                K.FStore.Shifts.state: newShift.upForGrabs,
                K.FStore.Shifts.start: newShift.startDate,
                K.FStore.Shifts.end: newShift.endDate
            ]) { err in
                if let err = err {
                    print("Error updating document: \(err)")
                } else {
                    print("Document successfully updated!")
                }
            }
            
        }
    }
    
    func deleteShift(_ shift: Shift) {
        db.collection(K.FStore.Shifts.collection).document(shift.FSID).delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
            }
        }
    }
    
    func loadShifts(role: String, uid: String, completionHandler: @escaping ((Array<Shift>?) -> Void)){
        if role == K.FStore.Employees.roles[0] {
            loadShiftsAdmin() { result in
                completionHandler(result)
            }
        } else {
            loadShiftsNormal(role: role, uid: uid) { result in
                completionHandler(result)
            }
        }
    }
    
    func loadShiftsAdmin(completionHandler: @escaping ((Array<Shift>?) -> Void)) { // Load all shifts
        db.collection(K.FStore.Shifts.collection).addSnapshotListener { (querySnapshot, error) in
            var result = [Shift]()
            
            if let e = error {
                print("There was an issue retriving shift data from Firestore. \(e)")
            } else {
                if let snapshotDocuments = querySnapshot?.documents {
                    for doc in snapshotDocuments {
                        let data = doc.data()
                        if let employee = data[K.FStore.Shifts.employee] as? String,
                           let endDate = data[K.FStore.Shifts.end] as? Timestamp,
                           let role = data[K.FStore.Shifts.role] as? String,
                           let startDate = data[K.FStore.Shifts.start] as? Timestamp,
                           let state = data[K.FStore.Shifts.state] as? Bool {
                            let newShift = Shift(employee: employee, endDate: endDate, role: role, startDate: startDate, upForGrabs: state, FSID: doc.documentID)
                            result.append(newShift)
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
    
    func loadShiftsNormal(role: String, uid: String, completionHandler: @escaping ((Array<Shift>?) -> Void)) { // Load only shifts specified to user or user's role
        db.collection(K.FStore.Shifts.collection).whereField(K.FStore.Shifts.employee, isEqualTo: uid).addSnapshotListener { (querySnapshot, error) in
            var shifts = [Shift]()
            
            if let e = error {
                print("There was an issue retriving shift data from Firestore. \(e)")
            } else {
                if let snapshotDocuments = querySnapshot?.documents {
                    for doc in snapshotDocuments {
                        let data = doc.data()
                        if let employee = data[K.FStore.Shifts.employee] as? String,
                           let endDate = data[K.FStore.Shifts.end] as? Timestamp,
                           let role = data[K.FStore.Shifts.role] as? String,
                           let startDate = data[K.FStore.Shifts.start] as? Timestamp,
                           let state = data[K.FStore.Shifts.state] as? Bool {
                            let newShift = Shift(employee: employee, endDate: endDate, role: role, startDate: startDate, upForGrabs: state, FSID: doc.documentID)
                            shifts.append(newShift)
                            DispatchQueue.main.async {
                                self.loadShiftsRole(role: role) { result in
                                    if result != nil {
                                        completionHandler(Array(Set(shifts).union(result!)))
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    func loadShiftsRole(role: String, completionHandler: @escaping LoadShiftsRoleClosure) {
        db.collection(K.FStore.Shifts.collection).whereField(K.FStore.Shifts.state, isEqualTo: true).whereField(K.FStore.Shifts.role, isEqualTo: role).addSnapshotListener { (querySnapshot, error) in
            var result = [Shift]()
            
            if let e = error {
                print("There was an issue retriving shift data from Firestore. \(e)")
            } else {
                if let snapshotDocuments = querySnapshot?.documents {
                    for doc in snapshotDocuments {
                        let data = doc.data()
                        if let employee = data[K.FStore.Shifts.employee] as? String,
                           let endDate = data[K.FStore.Shifts.end] as? Timestamp,
                           let role = data[K.FStore.Shifts.role] as? String,
                           let startDate = data[K.FStore.Shifts.start] as? Timestamp,
                           let state = data[K.FStore.Shifts.state] as? Bool {
                            let newShift = Shift(employee: employee, endDate: endDate, role: role, startDate: startDate, upForGrabs: state, FSID: doc.documentID)
                            result.append(newShift)
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
    }
    
    func changeStateOfShift(_ shift: Shift) {
        let shiftRef = db.collection(K.FStore.Shifts.collection).document(shift.FSID)
        
        shiftRef.updateData([
            "upForGrabs": !shift.upForGrabs
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
            }
        }
    }
    
    func takeShift(uid: String, shift: Shift) {
        let shiftRef = db.collection(K.FStore.Shifts.collection).document(shift.FSID)
        
        shiftRef.updateData([
            "employee": uid,
            "upForGrabs": !shift.upForGrabs
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
            }
        }
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
    
    func loadTasks(role: String, completionHandler: @escaping LoadTasksClosure) {
        db.collection(K.FStore.Tasks.collection).whereField(K.FStore.Tasks.team, isEqualTo: role)
            .addSnapshotListener { (querySnapshot, error) in
                var result = [Task]()
                
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
                                result.append(newTask)
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
    
}
