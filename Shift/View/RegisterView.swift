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
    @State var loginField: String = "login"
    @State var nameField: String = "name"
    @State var emailField: String = "email"
    @State var descriptionField: String = "description"
    @State var selectedRole: String = K.FStore.Employees.roles[0]
    @State var password1: String = ""
    @State var password2: String = ""
    @State private var showingAlert = false
    @State var alertMessage = "test"
    
    init(registerViewModel: RegisterViewModel) {
        self.registerViewModel = registerViewModel
    }
    
    var body: some View {
        ZStack {
            Color(.black).ignoresSafeArea()
            VStack {
                Group {
                    Text("📌 Login:")
                        .foregroundColor(.white)
                    TextField("Login...", text: $loginField)
                        .foregroundColor(.white)
                    Text("📌 Name:")
                        .foregroundColor(.white)
                    TextField("Name...", text: $nameField)
                        .foregroundColor(.white)
                    Text("✉️ Email:")
                        .foregroundColor(.white)
                    TextField("Email...", text: $emailField)
                        .foregroundColor(.white)
                }
                Group {
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
