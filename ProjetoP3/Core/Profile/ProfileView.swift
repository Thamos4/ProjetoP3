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
    @State private var selectedItem: PhotosPickerItem? = nil
    
    var body: some View {
        if let user = viewModel.currentUser {
            List {
                Section {
                    HStack{
                        Text(user.initials)
                            .font(.title)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .frame(width: 72, height: 72)
                            .background(Color(.systemGray3))
                            .clipShape(Circle())
                        
                        VStack(alignment: .leading, spacing: 4){
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
                
                Section("General") {
                    HStack(spacing: 12){
                        Image(systemName: "camera.fill")
                            .imageScale(.small)
                            .font(.title)
                            .foregroundColor(Color(.systemGray))
                        
                        PhotosPicker(selection: $selectedItem, matching: .images, photoLibrary: .shared()) {

                            Text("Edit Image")
                                .font(.subheadline)
                                .foregroundColor(.black)
                        }
                    }.onChange(of: selectedItem, perform: {
                        newValue in if let newValue {
                            viewModel.saveProfileImage(item: newValue)
                        }
                    })

                
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
                              primaryButton: .default(Text("Yes"), action:{
                            viewModel.deleteAccount(
                                selfUser: true,
                                user: viewModel.userSession!)
                                
                                showDeleteAlert = false
                            }),
                              secondaryButton: .default(Text("No"), action:{
                                showDeleteAlert = false
                            }))
                    }
                    
                }
                

                
            }
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        let authViewModel = AuthViewModel()
        authViewModel.currentUser = User.MOCK_USER
        
        return ProfileView()
            .environmentObject(authViewModel)
    }
}
