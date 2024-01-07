//
//  ArticleManager.swift
//  ProjetoP3
//
//  Created by user243107 on 1/4/24.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

@MainActor
class ArticleManager{
    static let shared = ArticleManager()
    private init() { }
    
    private let articlesCollection = Firestore.firestore().collection("articles")
    
    private func articleDocument(articleId: String) -> DocumentReference {
        articlesCollection.document(articleId)
    }
    
    func createArticle (article: Article) async throws{
        try articleDocument(articleId: article.id).setData(from: article, merge: false)
    }
    
    func createArticle (trackId: String, author: String, summary: String) async throws{
        let newArticleRef = articlesCollection.document()
        let id = newArticleRef.documentID
        let newArticle = Article(id: id, trackId: trackId, author: author, summary: summary)
        try newArticleRef.setData(from: newArticle)
    }
    
    func getArticle(articleId: String) async throws -> Article{
        try await articleDocument(articleId: articleId).getDocument(as: Article.self)
    }
    
    func updateArticle(article: Article) async throws {
        try articleDocument(articleId: article.id).setData(from: article, merge: true)
    }
    
    func getAllArticles() async throws -> [Article]{
        try await articlesCollection.getDocuments(as: Article.self)
    }
    
    func getAllArticlesForTrackId(trackId: String) async throws -> [Article]{
        try await articlesCollection.whereField("trackId", isEqualTo: trackId).getDocuments(as: Article.self)
    }
    
    func deleteArticle(articleId: String) async throws -> Void{
        do{
            try await articleDocument(articleId: articleId).delete()
        }catch{
            print("DEBUG: Made an oopsie deleting article u.u")
        }
    }
}

extension Query {
    func getDocuments<T>(as type: T.Type) async throws -> [T] where T : Decodable{
        let snapshot = try await self.getDocuments()
        
        return try snapshot.documents.map({ document in
            try document.data(as: T.self)
        })
    }
}
