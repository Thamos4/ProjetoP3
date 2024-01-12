//
//  Article.swift
//  ProjetoP3
//
//  Created by user243107 on 1/4/24.
//

import Foundation

enum ArticleRoom: String, Codable, CaseIterable {
    case room1 = "Room 1"
    case room2 = "Room 2"
    case room3 = "Room 3"
    case room4 = "Room 4"
}

struct Article: Identifiable, Codable {
    let id: String
    let trackId: String
    let conferenceId: String
    let title: String
    let author: String
    let summary: String
    let room: String
//    let pdfPath: String
}

// Mock Article

extension Article{
    static var MOCK_ARTICLE = Article(id: NSUUID().uuidString, trackId: NSUUID().uuidString, conferenceId: NSUUID().uuidString, title: "Artigo Épico", author: "José Saramago", summary: "Isto é uma descriçao bastante completa e totalmente honesta", room: "Room 1")
}
