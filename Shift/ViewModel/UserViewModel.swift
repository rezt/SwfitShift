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
    
    init(withUser newUser: User) {
        self.user = newUser
    }
    
    func editUser() {
        edit = !edit
    }
    
}
