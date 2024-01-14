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
    @State private var isError = false
    @State private var isSuccess = false
    
    
    var body: some View {
        NavigationStack {
        GeometryReader { geometry in
            ZStack{
                Color("HomeBG")
                    .ignoresSafeArea()
                
                //Figura azul
                Ellipse()
                    .fill(Color("TaskBG"))
                    .frame(width: geometry.size.width * 2.0, height: geometry.size.height * 0.50)
                    .position(x: geometry.size.width / 2, y: geometry.size.height * 0.1)
                    .shadow(radius: 3)
                    .edgesIgnoringSafeArea(.all)
                
                
                    VStack {
                        VStack(alignment: .leading){
                            HStack{ Spacer() }
                            Text("Forgot your password?.")
                                .font(.largeTitle)
                                .fontWeight(.semibold)
                            Text("Recover it now.")
                                .font(.title)
                                .fontWeight(.semibold)
                        }
                        .frame(height: 150)
                        .padding(.leading)
                        .foregroundColor(.white)
                        // form fields
                        VStack(spacing: 24) {
                            InputView(imageName: "envelope", placeholder: "Email", text: $email )
                                .autocapitalization(.none)
                            
                        }
                        .padding(.horizontal)
                        .padding(.top, 120)
                        
                        ButtonView(label: "SEND RESET LINK", icon: "arrow.right", iconOnLeft: false, isDisabled: !formIsValid){
                            Task {
                                do{
                                    try await viewModel.forgotPassword(email: email)
                                    self.isSuccess = true
                                    self.isError = false
                                }catch{
                                    self.isError = true
                                    self.isSuccess = false
                                }
                                
                            }
                        }.alert(isPresented: $isError) {
                            Alert(title: Text("Error Recovering account"),
                                  message: Text("Email was not found"),
                                  dismissButton: .default(Text("OK")))
                        }.alert(isPresented: $isSuccess) {
                            Alert(title: Text("Success"),
                                  message: Text("An email was sent to your inbox"),
                                  dismissButton: .default(Text("Ok")))
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
