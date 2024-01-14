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
            List {
                Section {
                    ZStack{
                                    
                        VStack{
                            HStack{
                            Spacer()
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
                        Spacer()
                        }
                            
                            
                            
                            VStack(alignment: .center, spacing: 4){
                                Text(user.fullname)
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                    .padding(.top, 4)
                                
                                Text(user.email)
                                    .font(.footnote)
                                    .foregroundColor(.gray)
                                
                            }
                        }
                    }
                }
                
                Section("General") {
                    HStack(spacing: 12){
                        Image(systemName: "camera.fill")
                            .imageScale(.small)
                            .font(.title)
                            .foregroundColor(Color(.systemGray))
                        
                        PhotosPicker(selection: $viewModel.selectedItem, matching: .images, photoLibrary: .shared()) {

                            Text("Edit Image")
                                .font(.subheadline)
                                .foregroundColor(.black)
                        }
                    }
                
                    SettingsRowView(imageName: "calendar", title: "Birthdate: \(user.birthdate) ", tintColor: Color(.systemGray))
                }
                
                Section("Account") {
                    Button{
                        viewModel.signOut()
                    } label: {
                        SettingsRowView(imageName: "arrow.left.circle.fill", title: "Sign Out", tintColor: Color(.red))
                    }
                    
                    Button{
                        showDeleteAlert = true
                    } label: {
                        SettingsRowView(imageName: "xmark.circle.fill", title: "Delete Account", tintColor: Color(.red))
                    }.alert(isPresented: $showDeleteAlert) {
                        Alert(title: Text("Delete Account"),
                              message: Text("Do you really want to delete your account? "),
                              primaryButton: .default(Text("Yes"), action: {
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
    
            }.background(Color("CardBG"))
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
