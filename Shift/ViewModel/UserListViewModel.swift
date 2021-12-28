//
//  UserListViewModel.swift
//  Shift
//
//  Created by Piotr Ćwiertnia on 28/12/2021.
//

import Foundation
import SwiftUI

final class UserListViewModel: ObservableObject {
    
    @Published var userRoles: [UserRole] = []
    @Published var showUser: Bool = false
    var userViewModel = UserViewModel(withUser: User(login: "", name: "", role: "", uid: ""))
    
    func getRoleOf(user: User) {
        userRoles.append(UserRole(uid: user.uid, role: user.role))
    }
    
    func getRoles(users: [User]) {
        for user in users {
            getRoleOf(user: user)
        }
    }
    
    func enter(user: User) {
        self.userViewModel = UserViewModel(withUser: user)
        showUser = true
    }
}
