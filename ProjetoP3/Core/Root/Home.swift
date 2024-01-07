//
//  LoginView.swift
//  ProjetoP3
//
//  Created by user243107 on 12/14/23.
//

import SwiftUI

struct Home: View {
    @State private var email = ""
    @State private var password = ""
    @EnvironmentObject var viewModel: AuthViewModel
    @State private var isError = false
    @State private var showWelcomeView = false
    
    var body: some View {
        if let user = viewModel.currentUser {
            NavigationStack {
                ZStack{
                    Color("HomeBG")
                    .ignoresSafeArea()
                    ScrollView {
                        VStack(alignment: .leading){
                            HStack{
                                Spacer()
                                if let image = viewModel.profileImage {
                                    image
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 40, height: 40)
                                        .cornerRadius(10)
                                        .clipShape(Circle())
                                } else {
                                    Image(systemName: "person")
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 40, height: 40)
                                        .clipShape(Circle())
                                        .padding([.top, .trailing], 14)
                                }
                
                            }
                            HStack{
                                Text("Manage\nyour tasks")
                                    .font(.system(size: 50))
                                VStack {
                                    if user.role == .admin {
                                        Button(action: { showWelcomeView = true }) {
                                            Text("Add Conference")
                                                .foregroundColor(.white)
                                                .padding(.horizontal)
                                                .padding(.vertical,8)
                                                .background(Color("TaskBG"))
                                                .clipShape(Capsule())
                                        }
                                    }

                                }
                                .navigationDestination(isPresented: $showWelcomeView) {
                                    CreateTask()
                                }
                            }
                        }
                        
                        //cards (pode ser outro background depois)
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 20) {
                              //  ForEach(0..<5) {
                                VStack {
                                    HStack{
                                        Spacer()
                                        
                                        Text("15/24/2024")
                                            .font(.caption)
                                            .padding(.horizontal)
                                            .padding(.top, 5)
                                            .clipShape(Capsule())
                                            .frame(minWidth: 0, maxHeight: .infinity, alignment: .topTrailing)
                                    }
                                   
                                    
                                    Text("Random conference 007")
                                        .font(.title3)
                                        .bold()
                                        .frame(minWidth: 0,minHeight: 125, maxHeight: 550, alignment: .top)
                                    Spacer()
                                }
                                //}
                            }
                            .foregroundStyle(.white)
                            .font(.largeTitle)
                            .frame(width: 175, height: 225)
                            .background(Color("TaskBG"))
                            .cornerRadius(10)
                            .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2)
                        }
                        
                        Text("Progress")
                            .font(.system(size: 25))
                            .padding(.top, 30)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        VStack(alignment: .leading, spacing: 15){
                            HStack {
                                Text("15/24/2024")
                                    .font(.caption)
                                    .padding(.horizontal)
                                    .padding(.vertical, 8)
                                    .background(.black.opacity(0.1))
                                    .foregroundColor(Color(.white))
                                    .clipShape(Capsule())
                                
                                Spacer()
                                
                            }
                            Text("Random conference 007")
                                .font(.title3)
                                .foregroundColor(Color(.white))
                                .bold()
                            
                            HStack{
                                Image(systemName: "person")
                                .foregroundColor(Color(.white))
                            }
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color("TaskBG"))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .padding()
                        .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2)
                        
                        VStack(alignment: .leading, spacing: 15){
                            HStack {
                                Text("15/24/2024")
                                    .font(.caption)
                                    .padding(.horizontal)
                                    .padding(.vertical, 8)
                                    .background(.black.opacity(0.1))
                                    .foregroundColor(Color(.white))
                                    .clipShape(Capsule())
                                
                                Spacer()
                                
                            }
                            Text("Random conference 007")
                                .font(.title3)
                                .foregroundColor(Color(.white))
                                .bold()
                            
                            HStack{
                                Image(systemName: "person")
                                .foregroundColor(Color(.white))
                            }
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color("TaskBG"))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .padding()
                        .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2)
                        
                    }
                    .padding(.horizontal)
                    .scrollIndicators(.hidden)
                }
            }.onAppear {
                Task {
                    let uiImage = try await StoreManager.shared.getImage(userId: user.id, path: user.profileImagePath)
                    
                    viewModel.profileImage = Image(uiImage: uiImage)
                }
            }
        }
    }
}


struct Home_Previews: PreviewProvider {
    static var previews: some View {
        let authViewModel = AuthViewModel()
        authViewModel.currentUser = User.MOCK_USER
        
        return Home()
            .environmentObject(authViewModel)
    }
}
