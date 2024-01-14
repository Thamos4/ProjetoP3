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
    @Published var users: [User] = []
    
    @Published var profileImage: Image?
    @Published var selectedItem: PhotosPickerItem? {
        didSet{ Task { try await loadImage() } }
    }

    init(){
        // Ve se esta algum user loggado na cache do dispositivo
        self.userSession = Auth.auth().currentUser
        
        Task {
            try await fetchUser()
        }
    }
    
    func signIn(email: String, password: String) async throws {
        let result = try await Auth.auth().signIn(withEmail: email, password: password)
        self.userSession = result.user
        try await fetchUser()
    }
    
    func createUser(email: String, fullname: String, password: String, birthdate: String) async throws {
        let result = try await Auth.auth().createUser(withEmail: email, password: password)
        self.userSession = result.user
        let user = User(id: result.user.uid, fullname: fullname, email: email, role: Role.user, birthdate: birthdate, profileImagePath: "")
        let encodedUser = try Firestore.Encoder().encode(user)
        try await Firestore.firestore().collection("users").document(user.id).setData(encodedUser)
            
        try await fetchUser()
    }
    
    func getUser(id:String) async throws -> User{
        try await UserManager.shared.getUser(userId: id)
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
    
    func deleteAccount() async throws {
        guard let user = Auth.auth().currentUser else { return } // deletes user from the auth table
        try await user.delete()
        try await Firestore.firestore().collection("users").document(user.uid).delete() // deletes user metadate from users collection
        clearSessionData()
    }
    
    func fetchUser() async throws {
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
            try await updateProfileImage(userId: userId, path: name)
            print(path)
            
        }
    }
    
    func loadImage() async throws {
        guard let item = selectedItem else { return }
        guard let imgData = try await item.loadTransferable(type: Data.self) else { return }
        guard let uiImage = UIImage(data: imgData) else { return }
        self.profileImage = Image(uiImage: uiImage)
    }
    
    func updateProfileImage(userId: String, path: String) async throws {
        try await Firestore.firestore().collection("users").document(userId).setData(["profileImagePath": path], merge: true)
    }
    
    func getAllUsers() async throws{
        self.users = try await UserManager.shared.getAllUsers()
    }
    
    func switchUserRole(userId: String) async throws{
        try await UserManager.shared.switchUserRole(userId: userId)
        
        if let index = users.firstIndex(where: { $0.id == userId }) {
            users[index].role.toggle()
        }
    }
}
