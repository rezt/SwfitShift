//
//  UserView.swift
//  Shift
//
//  Created by Piotr Ćwiertnia on 28/12/2021.
//

import Foundation
import SwiftUI

struct UserView: View {
    
    @ObservedObject var auth: LoginViewModel
    @ObservedObject var userViewModel: UserViewModel
    @ObservedObject var userListViewModel: UserListViewModel
    @State var selectedRole: String = "test"
    @Environment(\.presentationMode) var presentationMode
    
    init(userViewModel: UserViewModel, userListViewModel: UserListViewModel, loginViewModel: LoginViewModel) {
        self.auth = loginViewModel
        self.userViewModel = userViewModel
        self.userListViewModel = userListViewModel
    }
    
    
    var body: some View {
        VStack {
            Picker(selection: $selectedRole, label: Text("🏆 Role:").foregroundColor(.black)) {
                ForEach(K.FStore.Employees.roles, id: \.self) { role in
                    Text(role).foregroundColor(.black).tag(role)
                    }
                }
        }.onDisappear {
//            auth.save(user: userViewModel.user)
        }
        
    }
}
