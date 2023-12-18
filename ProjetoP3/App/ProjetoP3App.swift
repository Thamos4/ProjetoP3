//
//  ProjetoP3App.swift
//  ProjetoP3
//
//  Created by user243107 on 12/14/23.
//

import SwiftUI
import Firebase

@main
struct ProjetoP3App: App {
    @StateObject var authViewModel = AuthViewModel()
    
    init(){
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(authViewModel)
        }
    }
}
