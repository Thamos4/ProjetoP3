//
//  User.swift
//  ProjetoP3
//
//  Created by user243107 on 12/16/23.
//

import Foundation

enum Role: String, Codable {
    case admin = "Admin"
    case user = "User"
}

struct User: Identifiable, Codable {
    let id: String
    let fullname: String
    let email: String
    let role: Role
    let birthdate: String
    
    var initials: String {
        let formatter = PersonNameComponentsFormatter()
        if let components = formatter.personNameComponents(from: fullname){
            formatter.style = .abbreviated
            return formatter.string(from: components)
        }
        
        return ""
    }
    init(id: String, fullname: String, email: String, role: Role, birthdate: String) {
        self.id = id
        self.fullname = fullname
        self.email = email
        self.role = role
        self.birthdate = birthdate
    }
}


// Mock user
extension User {
    static var MOCK_USER = User(id: NSUUID().uuidString, fullname: "Gabriel Gomes", email: "gabriel.gomes@gmail.com", role: Role.user, birthdate: "30/03/2003"
    )
}
