//
//  MainViewModel.swift
//  Shift
//
//  Created by Piotr Ćwiertnia on 22/11/2021.
//

import Foundation
import Firebase
import SwiftUI

class MainViewModel: ObservableObject {
    
    var employees: [User] = []
    @Published var goToDisposition: Bool = false
    @Published var goToUsers: Bool = false
    var webService = WebService()
    
    typealias LoadEmployeesClosure = (Array<User>?) -> Void
    
    func loadEmployees(completionHandler: @escaping LoadEmployeesClosure) {
        webService.loadEmployees() { result in
            if result != nil {
                completionHandler(result!)
            }
        }
    }
    
    func getEmployees() -> [User] {
        return employees
    }
    
    func showDisposition() {
        goToDisposition = !goToDisposition
    }
    
    func showUserManagement() {
        goToUsers = !goToUsers
    }
}
