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
        let snapshot = try await usersCollection.getDocuments()

        var users: [User] = []
        for document in snapshot.documents{
            let user = try document.data(as: User.self)
            users.append(user)
        }
        return users
    }
  
    func deleteUser(userId: String) async throws {
        let uid = Auth.auth().currentUser?.uid
          
        let currentUserRef = userDocument(userId: userId)
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
          let updatedUser = User(id: user.id, fullname: user.fullname, email: user.email, role: role, birthdate: user.birthdate)
          try userDocument(userId: userId).setData(from: updatedUser, merge: true)
      }

      func resetPassword(userId: String) async throws {
          //
      }
}
