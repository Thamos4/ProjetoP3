//
//  User.swift
//  ProjetoP3
//
//  Created by user243107 on 12/16/23.
//

import Foundation

struct User: Identifiable, Codable {
    let id: String
    let fullname: String
    let email: String
    // TODO: Adicionar user image.
    
    var initials: String {
        let formatter = PersonNameComponentsFormatter()
        if let components = formatter.personNameComponents(from: fullname){
            formatter.style = .abbreviated
            return formatter.string(from: components)
        }
        
        return ""
    }
    
}

// Mock user
extension User {
    static var MOCK_USER = User(id: NSUUID().uuidString, fullname: "Gabriel Gomes", email: "gabriel.gomes@gmail.com")
}
