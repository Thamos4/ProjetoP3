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
        TabView{
            Home()
                .tabItem {Label("Home", systemImage: "house")}
            Home()
                .tabItem {Label("Search", systemImage: "magnifyingglass")}
           
            Group {
                if authViewModel.userSession != nil {
                    ProfileView()
                        .tabItem {Label("Profile", systemImage: "person")}
                } else {
                    LoginView().tabItem {Label("Profile", systemImage: "person")}
                }
            }
            
        }
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}
