//
//  AuthViewModel.swift
//  ProjetoP3
//
//  Created by user243107 on 12/17/23.
//

import Foundation
import Firebase

class AuthViewModel: ObservableObject {
    @Published var userSession: FirebaseAuth.User?
    @Published var currentUser: User?
    
    init(){
        
    }
    
    func signIn(email: String, password: String) async throws {
        
    }
    
    func createUser(userData: User) async throws {
        
    }
    
    func signOut() {
        
    }
    
    func deleteAccount() {
        
    }
    
    func fetchUser() {
        
    }
}
