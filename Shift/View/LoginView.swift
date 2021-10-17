//
//  ContentView.swift
//  Shift
//
//  Created by Piotr Ćwiertnia on 10/10/2021.
//

import SwiftUI
import Firebase

struct LoginView: View {
    @State private var isLoggedIn = false
    @State private var email: String = ""
    @State private var password: String = ""
    
    @ObservedObject var loginViewModel = LoginViewModel()
    
    var body: some View {
        NavigationView {
        VStack {
            NavigationLink(destination: MainView(), isActive: $isLoggedIn) {EmptyView()}
            Spacer()
            Text("Swift Shift").bold()
            Spacer()
            TextField("Login", text: $email).textContentType(.emailAddress).keyboardType(.emailAddress).autocapitalization(.none).disableAutocorrection(true)
            SecureField("Password", text: $password)
            Button(action: {loginViewModel.login(withEmail: email, withPassword: password)}) {
                Text("Log in")
            }
            Spacer()
            
        }
        }.navigationTitle("Login")
    }
}


struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
