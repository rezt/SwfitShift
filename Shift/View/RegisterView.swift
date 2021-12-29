//
//  RegisterView.swift
//  Shift
//
//  Created by Piotr Ćwiertnia on 29/12/2021.
//

import Foundation
import SwiftUI

struct RegisterView: View {
    @ObservedObject var auth: LoginViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @State var loginField: String = "login"
    @State var emailField: String = "email"
    @State var descriptionField: String = "description"
    @State var selectedRole: String = "role"
    @State var password1: String = ""
    @State var password2: String = ""
    
    init(loginViewModel: LoginViewModel) {
        self.auth = loginViewModel
    }
    
    var body: some View {
        ZStack {
            Color(.black).ignoresSafeArea()
            VStack {
                Text("📌 Login:")
                    .foregroundColor(.white)
                TextField("Login...", text: $loginField)
                    .foregroundColor(.white)
                Text("✉️ Email:")
                    .foregroundColor(.white)
                TextField("Email...", text: $emailField)
                    .foregroundColor(.white)
                Text("🔒 Password (at least 8 characters):")
                    .foregroundColor(.white)
                SecureField("Enter password", text: $password1).foregroundColor(.white)
                Text("🔓 Repeat password:")
                    .foregroundColor(.white)
                SecureField("Repeat password", text: $password2).foregroundColor(.white)
                Picker(selection: $selectedRole, label: Text("🏆 Role:").foregroundColor(.white)) {
                    ForEach(K.FStore.Employees.roles, id: \.self) { role in
                        Text(role).foregroundColor(.white).tag(role)
                        }
                    }
                Button {
                    
                } label: {
                    Text("🪄 Create user...")
                }

            }
        }
    }
}
