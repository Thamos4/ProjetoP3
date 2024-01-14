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
    let created_at: String
}

//MOCK COMMENT

extension articleComment{
    static var MOCK_COMMENT = articleComment(id: NSUUID().uuidString, articleId: NSUUID().uuidString, userId: NSUUID().uuidString, content: "EXAMPLE OF A COMMENT INCLUDED IN THE MOCK_COMMENT IN THE DECLARATION OF THE STRUCT ARTICLECOMMENT", created_at: "23/03/2003:11:50")
}
