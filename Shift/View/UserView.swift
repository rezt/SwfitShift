//
//  UserView.swift
//  Shift
//
//  Created by Piotr Ćwiertnia on 28/12/2021.
//

import Foundation
import SwiftUI

struct UserView: View {
    
    @ObservedObject var userViewModel: UserViewModel
    @ObservedObject var userListViewModel: UserListViewModel
    @State var selectedRole: String = "test"
    @Environment(\.presentationMode) var presentationMode
    
    init(userListViewModel: UserListViewModel) {
        self.userViewModel = userListViewModel.userViewModel
        self.userListViewModel = userListViewModel
    }
    
    
    var body: some View {
        ZStack {
            Color(.black).ignoresSafeArea()
            VStack {
                Text(userViewModel.user!.name).foregroundColor(.white)
                ZStack {
                    Color(.white)
                    Picker(selection: $selectedRole, label: Text("🏆 Role:").foregroundColor(.white)) {
                        ForEach(K.FStore.Employees.roles, id: \.self) { role in
                            Text(role).foregroundColor(.black).tag(role)
                            }
                        }
                    .pickerStyle(SegmentedPickerStyle())
                }.frame(maxHeight: 70)
                Button {
                    print(userViewModel.user!)
                    userViewModel.saveUser(withRole: selectedRole)
                } label: {
                    Text("💾 Save changes").foregroundColor(.white)
                }

            }
        }
    }
}
