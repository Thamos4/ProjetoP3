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
    @EnvironmentObject var viewModel: AuthViewModel
    
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
                
                
                // Forgot Password
                NavigationLink {
                    ForgotPasswordView()
                } label: {
                    HStack {
                        Text("Forgot Password?")
                            .fontWeight(.semibold)
                    }
                    .font(.system(size: 13))
                    .frame(width: UIScreen.main.bounds.width - 32, alignment: .trailing)
                    .padding(.top, 10)
                }
            
                // sign in button
                
                ButtonView(label: "SIGN IN", icon: "arrow.right", iconOnLeft: false, isDisabled: !formIsValid){
                    Task {
                       try await viewModel.signIn(email: email, password: password)
                    }
                    
                }

                Spacer()
        
                // sign up button
                
                NavigationLink {
                    RegistrationView()
                        .navigationBarBackButtonHidden(true)
                } label: {
                    HStack(spacing: 3){
                        Text("Don't have an account?")
                        Text("Sign up")
                            .fontWeight(.bold)
                    }
                    .font(.system(size: 14))
                }
            }
        }
    }
}

extension LoginView: AuthenticationFormProtocol {
    var formIsValid: Bool {
        return !email.isEmpty
        && email.contains("@") //TODO: Add better email validation
        && !password.isEmpty
        && password.count > 5
    }

}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
