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
    @State private var birthdate = Date()
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var isError = false
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: AuthViewModel
    
    
    func formattedDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter.string(from: date)
    }
    
    var body: some View {
        VStack {
            // form fields
            VStack(spacing: 24){
                InputView(text: $email, title: "Email", placeholder: "email@example.com")
                    .autocapitalization(.none)
                
                InputView(text: $fullname, title: "Full Name", placeholder: "Enter your name")
                
            DatePicker("Birthdate", selection: $birthdate, displayedComponents: .date)
                
                InputView(text: $password,
                          title: "Password",
                          placeholder: "Enter your password",
                        isSecureField: true)
                
                ZStack(alignment: .trailing){
                    InputView(text: $confirmPassword,
                              title: "Confirm Password",
                              placeholder: "Confirm your password",
                            isSecureField: true)
                    
                    if !password.isEmpty && !confirmPassword.isEmpty{
                        if password == confirmPassword {
                            Image(systemName: "checkmark.circle.fill")
                                .imageScale(.large)
                                .fontWeight(.bold)
                                .foregroundColor(Color(.systemGreen))
                        } else {
                            Image(systemName: "xmark.circle.fill")
                                .imageScale(.large)
                                .fontWeight(.bold)
                                .foregroundColor(Color(.systemRed))
                        }
                    }
                }

                
            }
            .padding(.horizontal)
            .padding(.top, 12)
            
            ButtonView(label: "SIGN UP", icon: "arrow.right", iconOnLeft: false, isDisabled: !formIsValid){
                Task {
                    do{
                        try await viewModel.createUser(email: email, fullname:fullname,
                            password: password,
                            birthdate: formattedDate(date: birthdate))
                    }catch{
                        self.isError = true
                    }

                }
            }.alert(isPresented: $isError) {
                Alert(title: Text("Failed to Sign Un"),
                      message: Text("Email is already in use"),
                      dismissButton: .default(Text("OK")))
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
        && birthdate < Date()
    }

}


struct RegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationView()
    }
}
