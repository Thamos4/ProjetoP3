//
//  Article.swift
//  ProjetoP3
//
//  Created by user243107 on 1/4/24.
//

import Foundation

struct Article: Identifiable, Codable {
    let id: String
    let trackId: String
    let title: String
    let author: String
    let summary: String
}

// Mock Article

extension Article{
    static var MOCK_ARTICLE = Article(id: NSUUID().uuidString, trackId: "whoknows", title: "MOCK TITLE", author: "MOCK AUTHOR", summary: "MOCK SUMMARY")
}
