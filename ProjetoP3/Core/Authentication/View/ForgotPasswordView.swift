//
//  ForgotPasswordView.swift
//  ProjetoP3
//
//  Created by user243107 on 12/20/23.
//

import SwiftUI

struct ForgotPasswordView: View {
    @State private var email = ""
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        
        NavigationStack {
            VStack {

                // form fields
                VStack(spacing: 24) {
                    InputView(text: $email, title: "Email", placeholder: "email@example.com")
                        .autocapitalization(.none)
                    
                }
                .padding(.horizontal)
                .padding(.top, 12)
                
                ButtonView(label: "SEND RESET LINK", icon: "arrow.right", iconOnLeft: false, isDisabled: !formIsValid){
                    Task {
                       viewModel.forgotPassword(email: email)
                    }
                    
                }
                
                Spacer()
                
                NavigationLink {
                    LoginView()
                        .navigationBarBackButtonHidden(true)
                } label: {
                    HStack(spacing: 3){
                        Text("Back to login?")
                            .fontWeight(.bold)
                    }
                    .font(.system(size: 14))
                }
            }
        }

    }
}

extension ForgotPasswordView: AuthenticationFormProtocol {
    var formIsValid: Bool {
        return !email.isEmpty
        && email.contains("@") //TODO: Add better email validation
    }

}

struct ForgotPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ForgotPasswordView()
    }
}
