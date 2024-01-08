//
//  ArticleComment.swift
//  ProjetoP3
//
//  Created by user243107 on 1/7/24.
//

import Foundation

struct articleComment: Identifiable, Codable {
    let id: String
    let articleId: String
    let userId: String
    let content: String
}

