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
    
    @Published var goToDisposition: Bool = false
    @Published var goToUsers: Bool = false
    @Published var goToPresets: Bool = false
    
    private var employees: [User] = []
    
    typealias LoadEmployeesClosure = (Array<User>?) -> Void
    
    func loadEmployees(completionHandler: @escaping LoadEmployeesClosure) {
        WebService.shared.loadEmployees() { result in
            if result != nil {
                completionHandler(result!)
            }
        }
    }
    
    func showDisposition() {
        goToDisposition = !goToDisposition
    }
    
    func showUserManagement() {
        goToUsers = !goToUsers
    }
    
    func showPresets() {
        goToPresets = !goToPresets
    }
    
}
