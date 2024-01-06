//
//  AdminDashboardView.swift
//  ProjetoP3
//
//  Created by user243107 on 1/5/24.
//

import SwiftUI

class AdminDashboardViewModel: ObservableObject {
    
    @Published private(set) var users: [User] = []
    
    func getAllUsers() async throws{
        print("DEBGUG: Called getAllUsers from ViewModel")
        self.users = try await UserManager.shared.getAllUsers()
    }
    
}

struct AdminDashboardView: View{
    @StateObject private var viewModel = AdminDashboardViewModel()
    
    var body: some View {
        NavigationStack{
            List {
                Text("Test")
//                ForEach(viewModel.users) {user in
//                    Text(user.fullname)
//                }
            }
            .navigationTitle("List of all users")
//            .task{
//                try? await viewModel.getAllUsers()
//            }
        }
    }
}


struct AdminDashboardView_Previews: PreviewProvider {
    static var previews: some View {
        AdminDashboardView()
    }
}
