//
//  Conference.swift
//  ProjetoP3
//
//  Created by user243107 on 1/7/24.
//

import Foundation

struct Conference: Identifiable, Codable {
    let id: String
    let name: String
    let beginDate: String
    let endDate: String
    let description: String
}
// Mock Conference

extension Conference{
    static var MOCK_CONFERENCE = Conference(id: NSUUID().uuidString, name: "Conferencia 1", beginDate: "14-01-2024", endDate: "15-01-2024", description: "Conferencia Cientifica epica")
}
