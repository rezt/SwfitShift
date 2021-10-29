//
//  ShiftApp.swift
//  Shift
//
//  Created by Piotr Ćwiertnia on 10/10/2021.
//

import SwiftUI
import Firebase

@main
struct ShiftApp: App {
    
    
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            LoginView()
        }
    }
}
