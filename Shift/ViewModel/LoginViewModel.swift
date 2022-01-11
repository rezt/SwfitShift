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
    
    func login(withEmail email: String, withPassword password: String) {
        WebService.shared.login(withEmail: email, withPassword: password) { result in
            if result != nil {
                UserService.shared.currentUser = result!
                self.isLoggedIn = true
            }
        }
    }
    
}
