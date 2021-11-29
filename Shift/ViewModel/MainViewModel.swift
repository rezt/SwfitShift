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
    @Published var userDetails = User(login: "", name: "", role: "", uid: "")
    @Published var showFinished = false
    
    
    // Get states and roles/teams
    func getConstants() {
        
    }
    
    func getDetails(forUserID userID: String) {
        
    }
}
