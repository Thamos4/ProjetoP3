//
//  CommentManager.swift
//  ProjetoP3
//
//  Created by user243107 on 1/11/24.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

@MainActor
class CommentManager {
    static let shared = CommentManager()
    private init() { }
    
    private let commentsCollection = Firestore.firestore().collection("article-comments")
    
    private func commentDocument(commentId: String) -> DocumentReference {
        commentsCollection.document(commentId)
    }
    
    func formattedDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy HH:mm:ss"
        return formatter.string(from: date)
    }
    
    func addComment(articleId: String, userId: String, content: String) async throws  -> articleComment {
        let newCommentRef = commentsCollection.document()
        let id = newCommentRef.documentID
        let newComment = articleComment(id: id, articleId: articleId, userId: userId, content: content, created_at: formattedDate(date: Date()))
        try newCommentRef.setData(from: newComment)
        
        return newComment
    }
    
    func getComment(commentId: String) async throws -> articleComment{
        return try await commentDocument(commentId: commentId).getDocument(as: articleComment.self)
    }
    
    func updateComment(articleComment: articleComment) async throws{
        try commentDocument(commentId: articleComment.id).setData(from: articleComment, merge: true)
    }
    
    func deleteComment(commentId: String) async throws{
        try await commentDocument(commentId: commentId).delete()
    }
    
    func getAllComments() async throws -> [articleComment]{
        try await commentsCollection.getDocuments(as: articleComment.self)
    }
    
    func getCommentsByArticleId(articleId: String) async throws -> [articleComment]{
        try await commentsCollection.whereField("articleId", isEqualTo: articleId).getDocuments(as: articleComment.self)
    }
  
}
