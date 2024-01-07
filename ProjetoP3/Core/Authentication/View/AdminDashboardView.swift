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
    
    
    var body: some View {
        NavigationStack{
            List {
                ForEach(viewModel.users) {user in
                    VStack{
                        Text(user.fullname)
                        Text(user.role.rawValue)
                        Button{
                            Task {
                                try await viewModel.switchUserRole(userId: user.id)
                            }
                        }label: {
                            Text("Switch Role")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(width: 340, height: 50)
                                .background(Color("TaskBG"))
                                .clipShape(Capsule())
                                .padding()
                        }

                    }
                }
            }
            .navigationTitle("List of all users")
            .task{
                try? await viewModel.getAllUsers()
            }
        }
    }
}


struct AdminDashboardView_Previews: PreviewProvider {
    static var previews: some View {
        AdminDashboardView()
    }
}
