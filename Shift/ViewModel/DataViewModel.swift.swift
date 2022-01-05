//
//  DataViewModel.swift.swift
//  Shift
//
//  Created by Piotr Ćwiertnia on 05/01/2022.
//

import Foundation

class DataViewModel {
    
    static var shared = DataViewModel()
    
    var presets: [Preset] = []
    var employees: [User] = []
    var user = User(login: "", name: "", role: "", uid: "", FSID: "")
    
    typealias LoginClosure = (Bool) -> Void
    
    func loadPresets() {
        WebService.shared.loadPresets { result in
            self.presets = result!
        }
    }
    
    func loadEmployees() {
        WebService.shared.loadEmployees() { result in
            self.employees = result!
        }
    }
    
    func login(withEmail email: String, withPassword password: String, completionHandler: @escaping LoginClosure) {
        WebService.shared.login(withEmail: email, withPassword: password) { result in
            if result != nil {
                self.user = result!
                completionHandler(true)
            }
        }
    }
}
