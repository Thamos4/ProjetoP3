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
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: AuthViewModel
    
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
            
            ButtonView(label: "SIGN UP", icon: "arrow.right", iconOnLeft: false, isDisabled: !formIsValid){
                Task {
                    try await viewModel.createUser(email: email, fullname: fullname,
                        password: password)
                }
            }
            
            Spacer()
            
            Button {
                dismiss()
            } label: {
                HStack(spacing: 3){
                    Text("Already have an account?")
                    Text("Sign In")
                        .fontWeight(.bold)
                }
                .font(.system(size: 14))
            }
        }
    }
}

extension RegistrationView: AuthenticationFormProtocol {
    var formIsValid: Bool {
        return !email.isEmpty
        && email.contains("@") //TODO: Add better email validation
        && !password.isEmpty
        && password.count > 5
        && confirmPassword == password
        && !fullname.isEmpty
    }

}


struct RegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationView()
    }
}
