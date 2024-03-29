//
//  CommentViewModel.swift
//  ProjetoP3
//
//  Created by user243107 on 1/11/24.
//

import Foundation



@MainActor
class CommentViewModel: ObservableObject {
    @Published var comments: [articleComment] = []
    
    func formattedDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy HH:mm"
        return formatter.string(from: date)
    }
    
    func addComment(articleId: String, userId: String, content: String) async throws -> articleComment {
        return try await CommentManager.shared.addComment(articleId: articleId, userId: userId, content: content)
    }
    
    
    func updateComment(id: String, articleId: String, userId: String, content: String) async throws {
        let newComment = articleComment(id: id, articleId: articleId, userId: userId, content: content, created_at: formattedDate(date: Date()))
        try await CommentManager.shared.updateComment(articleComment: newComment)
    }
    
    func deleteComment(id: String, articleId: String)async throws{
        try await CommentManager.shared.deleteComment(commentId: id)
        comments = try await CommentManager.shared.getCommentsByArticleId(articleId: articleId)
    }
    
    func getAllComments()async throws{
        comments = try await CommentManager.shared.getAllComments()
    }
    
    func getCommentsByArticleId(articleId: String)async throws{
        comments = try await CommentManager.shared.getCommentsByArticleId(articleId: articleId)
    }
}
