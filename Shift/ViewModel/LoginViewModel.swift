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
    @Published var userID: String = ""
    
    func login(withEmail email: String, withPassword password: String) {
        Auth.auth().signIn(withEmail: email, password: password) {authResult, error in
            if let e = error {
                print(e.localizedDescription)
            } else {
                self.isLoggedIn = true
                self.userID = Auth.auth().currentUser!.uid
            }
        }
    }
    
}

