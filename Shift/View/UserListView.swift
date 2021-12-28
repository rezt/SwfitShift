//
//  UserView.swift
//  Shift
//
//  Created by Piotr Ćwiertnia on 28/12/2021.
//

import Foundation
import SwiftUI

struct UserListView: View {
    
    @ObservedObject var auth: LoginViewModel
    @ObservedObject var userListViewModel: UserListViewModel
    @StateObject var userViewModel = UserViewModel(withUser: User(login: "", name: "", role: "", uid: ""))
    
    
    init(userListViewModel: UserListViewModel, loginViewModel: LoginViewModel) {
        self.auth = loginViewModel
        self.userListViewModel = userListViewModel
    }
    
    var body: some View {
        NavigationLink(destination: UserView(userViewModel: userViewModel, userListViewModel: userListViewModel, loginViewModel: auth), isActive: $userListViewModel.showUser) {}
        ZStack {
            Color(.black).ignoresSafeArea()
            ScrollView {
                VStack {
                    ForEach(auth.employees, id: \.self) { value in
                        userView(value: value)
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    func userView(value: User) -> some View {
        HStack {
            Text(value.name).foregroundColor(.white)
            Text(value.role).foregroundColor(.white)
            Button {
                userListViewModel.enter(user: value)
            } label: {
                Text("✏️")
            }

        }
    }
    
}
