//
//  RegistrationView.swift
//  ProjetoP3
//
//  Created by user243107 on 12/15/23.
//

import SwiftUI

struct RegistrationView: View {
    @State private var email = ""
    @State private var fullname = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    
    var body: some View {
        VStack {
            // form fields
            VStack(spacing: 24){
                InputView(text: $email, title: "Email", placeholder: "email@example.com")
                    .autocapitalization(.none)
                
                InputView(text: $fullname, title: "Full Name", placeholder: "Enter your name")
                
                InputView(text: $password,
                          title: "Password",
                          placeholder: "Enter your password",
                        isSecureField: true)
                    .autocapitalization(.none)
                
                InputView(text: $confirmPassword,
                          title: "Confirm Password",
                          placeholder: "Confirm your password",
                        isSecureField: true)
                    .autocapitalization(.none)
                
            }
            .padding(.horizontal)
            .padding(.top, 12)
            
            ButtonView(label: "SIGN UP", icon: "arrow.right", iconOnLeft: false){
                print("Sign user up..")
            }
        }
    }
}

struct RegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationView()
    }
}
