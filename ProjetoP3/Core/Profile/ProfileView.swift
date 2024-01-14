//
//  ProfileView.swift
//  ProjetoP3
//
//  Created by user243107 on 12/16/23.
//

import SwiftUI
import PhotosUI

struct ProfileView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @State private var showDeleteAlert = false
    @Binding var selectedTab: Tab

    var body: some View {
        if let user = viewModel.currentUser {
          
            GeometryReader { geometry in
                ZStack{
                    Color(.white)
                        .ignoresSafeArea()
                    
                    Ellipse()
                        .fill(Color("TaskBG"))
                        .frame(width: geometry.size.width * 2.0, height: geometry.size.height * 0.50)
                        .position(x: geometry.size.width / 2, y: geometry.size.height * 0.1)
                        .shadow(radius: 3)
                        .edgesIgnoringSafeArea(.all)

                    HStack {
                        VStack() {
                            PhotosPicker(selection: $viewModel.selectedItem){
                                if let profileImage = viewModel.profileImage{
                                    profileImage
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 100, height: 100)
                                        .cornerRadius(10)
                                        .clipShape(Circle())
                                } else {
                                    Text(user.initials)
                                        .font(.title)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.white)
                                        .frame(width: 100, height: 100)
                                        .background(Color(.systemGray3))
                                        .clipShape(Circle())
                                }
                            }.onChange(of: viewModel.selectedItem, perform: {
                                newValue in if let newValue {
                                    Task {
                                        viewModel.saveProfileImage(item: newValue)
                                    }
                                }
                            })
                            Text(user.fullname)
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .padding(.top, 4)
                                .foregroundColor(.white)
                            
                            
                            Spacer()
                            
                        }
                        .padding()
                        .padding(.top, 20)
                    }
                    
                    VStack(alignment: .leading, spacing: 10){
                        Text("General")
                            .font(.system(size: 25))
                            .padding(.vertical, 10)
                       
                        HStack(spacing: 12){
                            Image(systemName: "envelope.fill")
                                .imageScale(.small)
                                .font(.title)
                                .foregroundColor(Color(.systemGray))
                            
                            Text(user.email)
                                .font(.title3)
                                .foregroundColor(.black)
                        }
                        Divider()
                        
                        HStack(spacing: 12){
                            Image(systemName: "camera.fill")
                                .imageScale(.small)
                                .font(.title)
                                .foregroundColor(Color(.systemGray))
                            
                            PhotosPicker(selection: $viewModel.selectedItem, matching: .images, photoLibrary: .shared()) {

                                Text("Edit Image")
                                    .font(.title3)
                                    .foregroundColor(.black)
                            }
                            
                            
                        }
                        Divider()
                        SettingsRowView(imageName: "calendar", title: "\(user.birthdate) ", tintColor: Color(.systemGray))
                        
                        Text("Account")
                            .font(.system(size: 25))
                            .padding(.top, 20)
                        Button{
                            viewModel.signOut()
                        } label: {
                            SettingsRowView(imageName: "arrow.left.circle.fill", title: "Sign Out", tintColor: Color(.red))
                        }.padding(.top, 10)
                        
                        Divider()
                        
                        Button{
                            showDeleteAlert = true
                        } label: {
                            SettingsRowView(imageName: "xmark.circle.fill", title: "Delete Account", tintColor: Color(.red))
                        }.alert(isPresented: $showDeleteAlert) {
                            Alert(title: Text("Delete Account"),
                                  message: Text("Do you really want to delete your account? "),
                                  primaryButton: .default(Text("Yes"), action:{
                               
                                Task {
                                   try await viewModel.deleteAccount()
                                }
                               
                                    
                                    showDeleteAlert = false
                                }),
                                  secondaryButton: .default(Text("No"), action:{
                                    showDeleteAlert = false
                                }))
                        }
                    }
                    .padding(EdgeInsets(top: 80, leading: 21, bottom: 10, trailing: 21))
                    
                    
                }
            }
         
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        let authViewModel = AuthViewModel()
        authViewModel.currentUser = User.MOCK_USER
        
        return ProfileView(selectedTab: .constant(.profile))
            .environmentObject(authViewModel)
    }
}
