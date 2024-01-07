//
//  UserManager.swift
//  ProjetoP3
//
//  Created by user243107 on 1/4/24.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift
import FirebaseAuth

@MainActor
class UserManager{
    
    static let shared = UserManager()
    private init() { }
    private let usersCollection = Firestore.firestore().collection("users")

    private func userDocument(userId: String) -> DocumentReference{
        usersCollection.document(userId)
    }

    func getUser(userId: String) async throws -> User {
        try await userDocument(userId: userId).getDocument(as: User.self)
    }
    
    func getAllUsers() async throws -> [User]{
        try await usersCollection.getDocuments(as: User.self)
    }
  
    func deleteUser(userId: String) async throws {
        guard let uid = Auth.auth().currentUser?.uid else{
            print("DEBUG: Oopsie, couldn't get current user id :p")
            return
        }
          
        let currentUserRef = userDocument(userId: uid)
        let currentUser = try await currentUserRef.getDocument().data(as: User.self)
        
        if currentUser.id == userId {
          try await Auth.auth().currentUser?.delete()
          try await currentUserRef.delete()
          //clearSessionData()
        }else if currentUser.role == .admin{
          //try await Auth.auth().deleteUser(userId: userId)
          let userRef = userDocument(userId: userId)
          try await userRef.delete()
        }else{
          print("DEBUG: No permission! >.<")
        }
    }

      func switchUserRole(userId: String) async throws {
          let user = try await userDocument(userId: userId).getDocument().data(as: User.self)
          let role = (user.role == Role.user) ? Role.admin : Role.user
          //let updatedUser = User(id: user.id, fullname: user.fullname, email: user.email, role: role, birthdate: user.birthdate, )
          try await userDocument(userId: userId).setData(["role": role], merge: true)
      }

      func resetPassword(userId: String) async throws {
          //
      }
}
