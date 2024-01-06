//
//  ContentView.swift
//  ProjetoP3
//
//  Created by user243107 on 12/14/23.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    //@EnvironmentObject var
    
    var body: some View {
        Group {
            if authViewModel.userSession != nil {
                ProfileView()
            } else {
                //LoginView()
                AdminDashboardView()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
