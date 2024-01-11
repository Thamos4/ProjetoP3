//
//  CommentViewModel.swift
//  ProjetoP3
//
//  Created by user243107 on 1/11/24.
//

import Foundation

@MainActor
class CommentViewModel: ObservableObject {
  @Published var comments: [articleComment] = []{
    didSet{ Task { try await getAllComments()}}
  }

  func addComment(articleId: String, userId: String, content: String)async throws{
    try await ArticleManager.shared.addComment(articleId: articleId, userId: userId, content: content)
  }

    func updateComment(id: String, articleId: String, userId: String, content: String)async throws{
      let newComment = articleComment(id: id, articleId: articleId, userId: userId, content: content)
    try await CommentManager.shared.updateComment(articleComment: newComment)
  }
  
  func deleteComment(id: String)async throws{
    try await CommentManager.shared.deleteComment(commentId: id)
  }

  func getAllComments()async throws{
    comments = try await CommentManager.shared.getAllComments()
  }

  func getCommentsByArticleId(articleId: String)async throws{
    comments = try await CommentManager.shared.getCommentsByArticleId(articleId: articleId)
  }
}
