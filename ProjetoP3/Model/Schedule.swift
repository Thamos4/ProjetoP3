//
//  Schedule.swift
//  ProjetoP3
//
//  Created by Aluno ISTEC on 08/01/2024.
//

import Foundation

struct Schedule: Identifiable, Codable {
    let id: String
    let trackId: String
    let articleId: String
    let roomId: String
    let time: Date
}
