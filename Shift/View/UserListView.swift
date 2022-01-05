//
//  UserView.swift
//  Shift
//
//  Created by Piotr Ćwiertnia on 28/12/2021.
//

import Foundation
import SwiftUI

struct UserListView: View {
    
    @StateObject var userListViewModel = UserListViewModel()
    @StateObject var registerViewModel = RegisterViewModel()
    
    var body: some View {
        NavigationLink(destination: UserView(userListViewModel: userListViewModel), isActive: $userListViewModel.showUser) {}
        NavigationLink(destination: RegisterView(registerViewModel: registerViewModel), isActive: $userListViewModel.showRegister) {}
        ZStack {
            Color(.black).ignoresSafeArea()
            ScrollView {
                VStack {
                    Button {
                        userListViewModel.registerNew()
                    } label: {
                        Text("📄 New user")
                    }.padding()

                    ForEach(userListViewModel.employees, id: \.self) { value in
                        userView(value: value)
                    }
                }
            }
        }.onAppear(perform: {
            userListViewModel.loadEmployees()
        })
        .onDisappear(perform: {
            userListViewModel.detachEmployees()
        })
    }
    
    @ViewBuilder
    func userView(value: User) -> some View {
        HStack {
            Text(value.name).foregroundColor(.white)
            Text(value.role).foregroundColor(.white)
            Button {
                userListViewModel.enter(user: value)
            } label: {
                Text("✏️ Edit")
            }
            Button {
                userListViewModel.disable(user: value)
            } label: {
                Text("🗑 Delete")
            }

        }
    }
    
}
