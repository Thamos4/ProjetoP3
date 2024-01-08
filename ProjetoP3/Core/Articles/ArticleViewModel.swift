//
//  ArticleViewModel.swift
//  ProjetoP3
//
//  Created by user243107 on 1/7/24.
//

import Foundation
import SwiftUI

@MainActor
class ArticlesViewModel: ObservableObject{
    @Published private(set) var articles: [Article] = []
    
    func createArticle(trackId: String, author: String, summary: String) async throws {
        try await ArticleManager.shared.createArticle(trackId: trackId, author: author, summary: summary)
    }
    
    func updateArticle(id: String, trackId: String, author: String, summary: String) async throws{
        let newArticle = Article(id:id, trackId: trackId, author: author, summary: summary)
        try await ArticleManager.shared.updateArticle(article: newArticle)
    }
    
    func deleteArticle(id: String) async throws {
        try await ArticleManager.shared.deleteArticle(articleId: id)
    }
    
    func addComment(articleId: String, userId: String, content: String) async throws {
        try await ArticleManager.shared.addComment(articleId: articleId, userId: userId, content: content)
    }
}


