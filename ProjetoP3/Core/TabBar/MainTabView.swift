//
//  MainTabView.swift
//  ProjetoP3
//
//  Created by user243107 on 1/3/24.
//

import SwiftUI

struct MainTabView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    var body: some View {
        if authViewModel.userSession != nil {
            TabView{
                Home()
                    .tabItem {Label("Home", systemImage: "house")}

                ProfileView()
                    .tabItem {Label("Profile", systemImage: "person")}


                if let user = authViewModel.currentUser, user.role == .admin {

                    AdminDashboardView()
                        .tabItem {
                            Label("Dashboard", systemImage: "lock")
                        }
                }
            }
        } else {
            LoginView()
        }
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}
