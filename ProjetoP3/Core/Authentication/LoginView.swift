//
//  LoginView.swift
//  ProjetoP3
//
//  Created by user243107 on 12/14/23.
//

import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    
    var body: some View {
        NavigationStack {
            VStack{
                // image (dps arranjamos um logo)
                
                // form fields
                VStack(spacing: 24){
                    InputView(text: $email, title: "Email", placeholder: "email@example.com")
                        .autocapitalization(.none)
                    
                    InputView(text: $password,
                              title: "Password",
                              placeholder: "Enter your password",
                            isSecureField: true)
                        .autocapitalization(.none)
                    
                }
                .padding(.horizontal)
                .padding(.top, 12)
                
                // sign in button
                Spacer()
                
                // sign up button
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
