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
    var webService = WebService()
    
    func showDisposition() {
        goToDisposition = !goToDisposition
    }
    
    func showUserManagement() {
        goToUsers = !goToUsers
    }
}
