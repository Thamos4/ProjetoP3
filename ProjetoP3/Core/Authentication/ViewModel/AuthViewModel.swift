//
//  AuthViewModel.swift
//  ProjetoP3
//
//  Created by user243107 on 12/17/23.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift
import SwiftUI
import PhotosUI

protocol AuthenticationFormProtocol {
    var formIsValid: Bool { get }
}

@MainActor //Para o codigo correr na main thread
class AuthViewModel: ObservableObject {
    @Published var userSession: FirebaseAuth.User?
    @Published var currentUser: User?

    init(){
        // Ve se esta algum user loggado na cache do dispositivo
        self.userSession = Auth.auth().currentUser
        
        Task {
            await fetchUser()
        }
    }
    
    func signIn(email: String, password: String) async throws {
        let result = try await Auth.auth().signIn(withEmail: email, password: password)
        self.userSession = result.user
        await fetchUser()
    }
    
    func createUser(email: String, fullname: String, password: String, birthdate: String) async throws {
        let result = try await Auth.auth().createUser(withEmail: email, password: password)
        self.userSession = result.user
        let user = User(id: result.user.uid, fullname: fullname, email: email, role: Role.user, birthdate: birthdate)
        let encodedUser = try Firestore.Encoder().encode(user)
        try await Firestore.firestore().collection("users").document(user.id).setData(encodedUser)
            
        await fetchUser()
    }
    
    func forgotPassword(email: String) async throws{
        try await Auth.auth().sendPasswordReset(withEmail: email)
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut() // Da sign out ao user no backend
            clearSessionData()
        } catch {
            print("DEBUG: Failed to sign out with error \(error.localizedDescription)")
        }
    }
    
    //selfUser: the current logged in user decided do delete is own account
    func deleteAccount(selfUser: Bool, user: FirebaseAuth.User) {
        user.delete() // deletes user from the auth table
        Firestore.firestore().collection("users").document(user.uid).delete() // deletes user metadate from users collection
        
        if selfUser {
            clearSessionData()
        }

    }
    
    func fetchUser() async {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let snapshot = try? await Firestore.firestore().collection("users").document(uid).getDocument() else { return }
        self.currentUser = try? snapshot.data(as: User.self)

    }
    
    func clearSessionData (){
        self.userSession = nil // Limpa a sessao do user e leva nos para o login
        self.currentUser = nil // Limpa o data model do user
    }
    
    func saveProfileImage(item: PhotosPickerItem){
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        Task {
            guard let data = try await item.loadTransferable(type: Data.self) else { return }
            let (path, name) = try await StoreManager.shared.saveImage(data: data, userId: userId )
            print("lol123")
            print(path)
            print(name)
        }
    }
}
