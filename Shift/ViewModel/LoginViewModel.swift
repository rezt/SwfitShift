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
    
    func login(withEmail email: String, withPassword password: String) {
        WebService.shared.login(withEmail: email, withPassword: password) { result in
            if result != nil {
                self.user = result!
                self.isLoggedIn = true
            }
        }
    }
    
}
