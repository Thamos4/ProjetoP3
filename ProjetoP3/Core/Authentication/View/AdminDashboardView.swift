//
//  AdminDashboardView.swift
//  ProjetoP3
//
//  Created by user243107 on 1/5/24.
//

import SwiftUI

struct AdminDashboardView: View{
    @StateObject private var authViewModel = AuthViewModel()
    
    var body: some View {
        NavigationStack{
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
                    
                    
                    VStack{
                        VStack{
                            Text("Users List")
                                .font(.title)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                            
                        }
                        .frame(height:150)
                        .padding(.bottom, 50)
                        
                        Spacer()
                        
                        ScrollView(.vertical, showsIndicators: false) {
                            VStack{
                                Divider()
                                ForEach(authViewModel.users) {user in
                                    HStack(alignment: .center){
                                        Text(user.fullname)
                                            .multilineTextAlignment(.leading)
                            
                                        Spacer()
                                            Button {
                                                Task {
                                                    try await authViewModel.switchUserRole(userId: user.id)
                                                }
                                            } label: {
                                                Text("Switch Role")
                                                    .font(.system(size: 14))
                                                    .padding(.vertical, 10)
                                                    .padding(.horizontal, 12)
                                            }
                                            .frame(width: 100, height: 30)
                                            .background(Color("TaskBG"))
                                            .clipShape(Capsule())
                                            .foregroundColor(.white)
                                            .disabled(user.id == authViewModel.currentUser?.id)
                                            .opacity(user.id == authViewModel.currentUser?.id ? 0.5 : 1)
                                    }
                                    .overlay(Text(user.role.rawValue))
                                    .padding(.horizontal)
                                    Divider()
                                }
                            }
                            .padding(.top, 25)
                        }
                        

                    }
                    .task{
                        try? await authViewModel.getAllUsers()
                    }
                }
            }
        }
    }
}

struct AdminDashboardView_Previews: PreviewProvider {
    static var previews: some View {
        AdminDashboardView()
    }
}
