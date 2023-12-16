//
//  ProfileView.swift
//  ProjetoP3
//
//  Created by user243107 on 12/16/23.
//

import SwiftUI

struct ProfileView: View {
    var body: some View {
        List {
            Section {
                HStack{
                    Text("JD")
                        .font(.title)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(width: 72, height: 72)
                        .background(Color(.systemGray3))
                        .clipShape(Circle())
                    
                    VStack(alignment: .leading, spacing: 4){
                        Text("Jhon Doe")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .padding(.top, 4)
                        
                        Text("jhon.doe@gmail.com")
                            .font(.footnote)
                            .accentColor(.gray)
                            
                    }
                }

            }
            
            Section("General") {
                SettingsRowView(imageName: "camera.fill", title: "Edit Image", tintColor: Color(.systemGray))
            }
            
            Section("Account") {
                Button{
                    print("Sign out...")
                } label: {
                    SettingsRowView(imageName: "arrow.left.circle.fill", title: "Sign Out", tintColor: Color(.red))
                }
                
                Button{
                    print("Delete Account...")
                } label: {
                    SettingsRowView(imageName: "xmark.circle.fill", title: "Delete Account", tintColor: Color(.red))
                }
                
            }
            
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
