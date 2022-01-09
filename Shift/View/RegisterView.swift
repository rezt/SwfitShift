//
//  RegisterView.swift
//  Shift
//
//  Created by Piotr Ćwiertnia on 29/12/2021.
//

import Foundation
import SwiftUI

struct RegisterView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject var registerViewModel: RegisterViewModel
    @State private var loginField: String = ""
    @State private var nameField: String = ""
    @State private var emailField: String = ""
    @State private var selectedRole: String = K.FStore.Employees.roles[0]
    @State private var password1: String = ""
    @State private var password2: String = ""
    @State private var showingAlert = false
    @State private var alertMessage = "test"
    
    init(registerViewModel: RegisterViewModel) {
        self.registerViewModel = registerViewModel
    }
    
    var body: some View {
        ZStack {
            Color(.black).ignoresSafeArea()
            Form {
                Section {
                    Group {
                        Text("📌 Login:")
                        TextField("Login...", text: $loginField)
                        Text("📌 Name:")
                        TextField("Name...", text: $nameField)
                        Text("✉️ Email:")
                        TextField("Email...", text: $emailField)
                    }
                    Group {
                        Text("🔒 Password (at least 8 characters):")
                        SecureField("Enter password", text: $password1).foregroundColor(.white)
                        Text("🔓 Repeat password:")
                        SecureField("Repeat password", text: $password2).foregroundColor(.white)
                        Picker(selection: $selectedRole, label: Text("🏆 Role:").foregroundColor(.white)) {
                            ForEach(K.FStore.Employees.roles, id: \.self) { role in
                                Text(role).tag(role)
                                }
                            }
                    }
                }
                Section {
                    Button {
                        let result = RegisterViewModel.check(password: password1, with: password2, email: emailField)
                        switch result {
                        case .good:
                            registerViewModel.createUser(User(login: loginField, name: nameField, role: selectedRole, uid: "", FSID: ""), email: emailField, password: password1)
                            print("good")
                        default:
                            alertMessage = result.rawValue
                            showingAlert = true
                        }
                    } label: {
                        Text("🪄 Create user...")
                    }.alert(alertMessage, isPresented: $showingAlert) {
                        Button("OK", role: .cancel) { }
                }
            }
            }
    }
}

}
