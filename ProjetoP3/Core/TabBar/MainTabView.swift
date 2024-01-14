//
//  MainTabView.swift
//  ProjetoP3
//
//  Created by user243107 on 1/3/24.
//

import SwiftUI

enum Tab {
    case home, profile, dashboard
}

struct MainTabView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    
    @State private var selectedTab: Tab = .home
    
    func updateSelectedTab(tab: Tab) {
        selectedTab = tab
    }
    
    var body: some View {
        if $authViewModel.userSession.wrappedValue != nil {
            TabView(selection: $selectedTab){
                Home(selectedTab: $selectedTab)
                    .tabItem {Label("Home", systemImage: "house")}
                    .tag(Tab.home)

                if let user = authViewModel.currentUser, user.role == .admin {
                    
                    AdminDashboardView()
                        .tabItem {
                            Label("Dashboard", systemImage: "lock")
                        }
                        .tag(Tab.dashboard)
                }
                
                ProfileView(selectedTab: $selectedTab)
                    .tabItem {Label("Profile", systemImage: "person")}
                    .tag(Tab.profile)
                
            }.onAppear {
                selectedTab = .home
            }
        } else {
            LoginView()
        }
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        let authViewModel = AuthViewModel()
        return MainTabView()
            .environmentObject(authViewModel)
    }
}
