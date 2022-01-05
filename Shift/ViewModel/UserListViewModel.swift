//
//  UserListViewModel.swift
//  Shift
//
//  Created by Piotr Ćwiertnia on 28/12/2021.
//

import Foundation
import SwiftUI

final class UserListViewModel: ObservableObject {
    
    @Published var employees: [User] = []
    @Published var userRoles: [UserRole] = []
    @Published var showUser: Bool = false
    @Published var showRegister: Bool = false
    var userViewModel = UserViewModel(withUser: User(login: "", name: "", role: "", uid: "", FSID: ""))
    
    init() {
    }
    
    func setEmployees(_ users: [User]) {
        employees = users
    }
    
    func getRoleOf(user: User) {
        userRoles.append(UserRole(uid: user.uid, role: user.role))
    }
    
    func getRoles(users: [User]) {
        for user in users {
            getRoleOf(user: user)
        }
    }
    
    func enter(user: User) {
        print(user)
        self.userViewModel = UserViewModel(withUser: user)
        showUser = true
    }
    
    func registerNew() {
        print("register")
        showRegister = true
    }
    
    func disable(user: User) {
        WebService.shared.disable(user: user)
    }
}
