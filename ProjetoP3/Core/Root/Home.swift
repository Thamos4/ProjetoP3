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
    @StateObject var conferenceViewModel = ConferenceViewModel()
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
                                
                            }.padding(.horizontal)
                            HStack{
                                Text("Welcome")
                                    .font(.system(size: 50))
                            }.padding(.horizontal)
                        }
                        
                        
                        HStack {
                            Text("Conferences")
                                .font(.system(size: 25))
                                .padding(.top, 5)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            VStack {
                                if user.role == .admin {
                                    NavigationButton(label: "Add Conference", icon: "plus", destination: AddConferenceView())
                  
                                }
                                
                            }
                        }.padding(.horizontal)
                        
                        
                        if(conferenceViewModel.conferences.count > 0) {
                            ForEach(conferenceViewModel.conferences) { conference in
                                NavigationLink(destination: ConferenceView(conference: conference)
                                    .navigationBarBackButtonHidden(true)
                                ){
                                    ConferenceContainerView(conference: conference)
                                }
                            }
                        } else {
                            Text("No Available Conferences")
                                .font(.system(size: 25))
                                .padding(.top, 5)
                                .padding(.horizontal)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }

                    }
                }
            }.onAppear {
                Task {
                    try await conferenceViewModel.setAllConferences()
                    
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
