//
//  UserViewModel.swift
//  Shift
//
//  Created by Piotr Ćwiertnia on 28/12/2021.
//

import Foundation

final class UserViewModel: ObservableObject {
    @Published var user: User?
    @Published var edit: Bool = false
    var webService = WebService()
    
    init(withUser newUser: User) {
        self.user = newUser
    }
    
    func editUser() {
        edit = !edit
    }
    
    func saveUser(withRole role: String) {
        webService.saveUser(user!, selectedRole: role)
    }
    
}
