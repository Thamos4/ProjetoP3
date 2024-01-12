//
//  ArticleViewModel.swift
//  ProjetoP3
//
//  Created by user243107 on 1/7/24.
//

import Foundation
import SwiftUI

@MainActor
class ArticleViewModel: ObservableObject{
    @Published var articles: [Article] = []{
        didSet{ Task { try await getAllArticles()}}
    }
    
    func createArticle(trackId: String, conferenceId: String,title: String, author: String, summary: String, room: String) async throws {
        try await ArticleManager.shared.createArticle(trackId: trackId, conferenceId: conferenceId,title: title, author: author, summary: summary, room: room)
    }
    
    func updateArticle(id: String, trackId: String, conferenceId: String,title: String, author: String, summary: String, room: String) async throws{
        let newArticle = Article(id:id, trackId: trackId, conferenceId: conferenceId,title: title, author: author, summary: summary, room: room)
        try await ArticleManager.shared.updateArticle(article: newArticle)
    }
    
    func deleteArticle(id: String) async throws {
        try await ArticleManager.shared.deleteArticle(articleId: id)
    }
    
    func addComment(articleId: String, userId: String, content: String) async throws {
        try await ArticleManager.shared.addComment(articleId: articleId, userId: userId, content: content)
    }
    
    func getAllArticles() async throws{
        try await articles =  ArticleManager.shared.getAllArticles()
    }
    
    func searchArticle(articleTitle: String) async throws{
        articles = articles.filter({ article in
            return article.title.lowercased().contains(articleTitle.lowercased())
        })
    }
}
