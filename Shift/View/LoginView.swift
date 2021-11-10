//
//  ContentView.swift
//  Shift
//
//  Created by Piotr Ćwiertnia on 10/10/2021.
//

import SwiftUI
import Firebase

struct LoginView: View {
    @StateObject private var auth = LoginViewModel()
    @State private var email: String = "admin@test.pl"
    @State private var password: String = "adminadmin"
    
    var body: some View {
        NavigationView {
            ZStack{
                Color.black
                    .ignoresSafeArea()
                VStack {
                    NavigationLink(destination: MainView(userID: $auth.userID), isActive: $auth.isLoggedIn) {EmptyView()}
                    Spacer()
                    Text("Swift Shift")
                        .bold()
                        .font(.largeTitle)
                        .foregroundColor(.white)
                    Spacer()
                    Text("Login:").bold().font(.largeTitle).foregroundColor(.white)
                        TextField("", text: $email)
                            .textContentType(.emailAddress)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                            .modifier(CustomViewModifier(roundedCornes: 5, startColor: .purple, endColor: .indigo, textColor: .white))
                            .padding()
                        Text("Password:").bold().font(.largeTitle).foregroundColor(.white)
                        SecureField("PASSWORD", text: $password)
                            .modifier(CustomViewModifier(roundedCornes: 5, startColor: .purple, endColor: .indigo, textColor: .white))
                            .padding()
                    
                    
                    Button(action: {auth.login(withEmail: email, withPassword: password)}) {
                        Text("Log in").font(.title)
                    }
                    Spacer()
                }
            }.navigationTitle("Login")
        }
        
    }
}

struct CustomViewModifier: ViewModifier {
    var roundedCornes: CGFloat
    var startColor: Color
    var endColor: Color
    var textColor: Color
    
    func body(content: Content) -> some View {
        content
            .padding()
            .background(LinearGradient(gradient: Gradient(colors: [startColor, endColor]), startPoint: .topLeading, endPoint: .bottomTrailing))
            .cornerRadius(roundedCornes)
            .padding(5)
            .foregroundColor(textColor)
            .overlay(RoundedRectangle(cornerRadius: roundedCornes)
                        .stroke(LinearGradient(gradient: Gradient(colors: [startColor, endColor]), startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 5))
        
            .shadow(radius: 10)
    }
}



struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
