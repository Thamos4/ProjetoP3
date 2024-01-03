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
    @State private var isError = false
    
    var body: some View {
        NavigationStack {
            VStack{
                // image (dps arranjamos um logo)
                
                //Blue stack (pode ser outro background depois)
                VStack(alignment: .leading){
                    HStack{ Spacer() }
                    Text("Hello.")
                        .font(.largeTitle)
                        .fontWeight(.semibold)
                    Text("Welcome back.")
                        .font(.largeTitle)
                        .fontWeight(.semibold)
                }
                .frame(height: 260)
                .padding(.leading)
                .background(Color(.systemCyan))
                .foregroundColor(.white)
                
                // form fields
                VStack(spacing: 24){
                    InputView(imageName: "envelope", placeholder: "Email", text: $email)
                        .autocapitalization(.none)
                    
                    InputView(imageName: "lock",
                              placeholder: "Enter your password",
                              text: $password,
                              isSecureField: true)
                        .autocapitalization(.none)
                    
                }
                .padding(.horizontal)
                .padding(.top, 12)
                
                
                // Forgot Password
                NavigationLink {
                    ForgotPasswordView()
                        .navigationBarBackButtonHidden(true)
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
                        do{
                            try await viewModel.signIn(email: email, password: password)
                        }catch{
                            self.isError = true
                        }
                       
                    }
                }.alert(isPresented: $isError) {
                    Alert(title: Text("Failed to Sign In"),
                          message: Text("Invalid Email or Password"),
                          dismissButton: .default(Text("OK")))
                }

                Spacer()
        
                // sign up button
                
                NavigationLink {
                    RegistrationView()
                        .navigationBarBackButtonHidden(true)
                } label: {
                    HStack(spacing: 3){
                        Text("Don't have an account?").foregroundColor(.black)
                        Text("Sign up")
                            .fontWeight(.bold)
                    }
                    .font(.system(size: 14))
                }
            }
        }
        .toolbar(.hidden, for: .tabBar)
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
