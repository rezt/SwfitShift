//
//  UserService.swift
//  Shift
//
//  Created by Piotr Ćwiertnia on 05/01/2022.
//

import Foundation

class UserService {
    static var shared = UserService()
    var currentUser = User(login: "", name: "", role: "", uid: "", FSID: "")
}
