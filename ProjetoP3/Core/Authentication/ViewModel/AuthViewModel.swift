//
//  AuthViewModel.swift
//  ProjetoP3
//
//  Created by user243107 on 12/17/23.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

@MainActor //Para o codigo correr na main thread
class AuthViewModel: ObservableObject {
    @Published var userSession: FirebaseAuth.User?
    @Published var currentUser: User?
    
    init(){
        // Ve se esta algum user loggado na cache do dispositivo
        self.userSession = Auth.auth().currentUser
    }
    
    func signIn(email: String, password: String) async throws {
        print("Sign in...")
    }
    
    func createUser(email: String, fullname: String, password: String) async throws {
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            self.userSession = result.user
            let user = User(id: result.user.uid, fullname: fullname, email: email)
            let encodedUser = try Firestore.Encoder().encode(user)
            try await Firestore.firestore().collection("users").document(user.id).setData(encodedUser)
        } catch {
            print("DEBUG: Failed to create user with error \(error.localizedDescription)")
        }
    }
    
    func signOut() {
        
    }
    
    func deleteAccount() {
        
    }
    
    func fetchUser() async {
        
    }
}
