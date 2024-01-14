//
//  AdminDashboardView.swift
//  ProjetoP3
//
//  Created by user243107 on 1/5/24.
//

import SwiftUI

@MainActor
class AdminDashboardViewModel: ObservableObject {
    @Published private(set) var users: [User] = []
    
    func getAllUsers() async throws{
        print("DEBGUG: Called getAllUsers from ViewModel")
        self.users = try await UserManager.shared.getAllUsers()
    }
    
    func switchUserRole(userId: String) async throws{
        try await UserManager.shared.switchUserRole(userId: userId)
        
        if let index = users.firstIndex(where: { $0.id == userId }) {
            users[index].role.toggle()
        }
    }
    
}

struct AdminDashboardView: View{
    @StateObject private var viewModel = AdminDashboardViewModel()
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
                            Text("List of all Users")
                                .font(.title)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                            
                        }
                        .frame(height:150)
                        .padding(.bottom, 50)
                        
                        Spacer()
                        
                        VStack{
                            ForEach(viewModel.users) {user in
                                HStack{
                                    
                                    Text(user.fullname)
                                        .multilineTextAlignment(.leading)
                                    Spacer()
                                    if(user.id != authViewModel.currentUser?.id){
                                        Button{
                                            Task {
                                                try await viewModel.switchUserRole(userId: user.id)
                                            }
                                        }label: {
                                            Text("Switch Role")
                                                .font(.headline)
                                                .foregroundColor(.white)
                                                .frame(width: 120, height: 30)
                                                .background(Color("TaskBG"))
                                                .clipShape(Capsule())
                                                
                                        }.padding(.vertical, 10)
                                    }
                                    
                                }
                                .overlay(Text(user.role.rawValue))
                                .padding(.horizontal)
                               
                            }
                        }.padding(.bottom, 300)
                    }
                    .task{
                        try? await viewModel.getAllUsers()
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
