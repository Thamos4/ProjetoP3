//
//  ArticleView.swift
//  ProjetoP3
//
//  Created by user243107 on 1/7/24.
//

import SwiftUI

struct ArticleView: View {
    @EnvironmentObject var userViewModel: AuthViewModel
    @StateObject var articleViewModel = ArticleViewModel()
    @StateObject var commentViewModel = CommentViewModel()
    @State private var currentCommentList: [articleComment] = []
    @State private var newCommentContent: String = ""
    let article: Article
   
    var body: some View {
        NavigationStack{
            VStack {
                HStack{
                    NavigationLink(destination: Home()
                        .navigationBarBackButtonHidden(true)) {
                        Image(systemName: "arrow.left")
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }.foregroundColor(.black)
                    
    //                Image(systemName: "magnifyingglass")
                   
                    
                }.padding(.horizontal)
                .padding(.bottom, 12)
                .font(.system(size: 16))
                
                VStack{
                    HStack {
                        Text(article.title)
                            .font(.title)
                            .padding(.top, 5)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }.padding(.horizontal)
                        .padding(.top, 12)
                    HStack {
                        Image(systemName: "person.fill")
                            .frame(width: 20, height: 20)
                        Text(article.author)
                            .font(.system(size: 14))
                    }.padding(.horizontal)
                    HStack {
                        Image(systemName: "door.right.hand.closed")
                            .frame(width: 20, height: 20)
                        Text(article.room)
                            .font(.system(size: 14))
                    }
                    HStack {
                        Image(systemName: "doc.text.fill")
                            .frame(width: 20, height: 20)
                        Text(article.summary)
                            .font(.system(size: 14))
                    }
                    Spacer()
                    HStack{
                        InputView(imageName: "pencil", placeholder: "Write a question here", text: $newCommentContent)
                        Button{
                            Task {
                                try await commentViewModel.addComment(articleId: article.id, userId: userViewModel.currentUser!.id,content: newCommentContent)
                                newCommentContent = ""
                                print("DEBUG: Pressed add comment button")
                            }
                        }label:{ Image(systemName: "paperplane")
                                .font(.system(size: 20))
                                .foregroundColor(.white)
                                .padding(12)
                                .background(Color.blue)
                                .clipShape(Circle())
                        }
                        .disabled(!formIsValid)
                        .opacity(!formIsValid ? 0.5 : 1.0)
                    }
                    
                }.onAppear{
                    Task {
                        try await commentViewModel.getCommentsByArticleId(articleId:article.id)
                        currentCommentList = commentViewModel.comments
                    }
                }
            }
            .padding(.top, 12)
            .padding(.horizontal)
            
            
            
            ForEach(currentCommentList){ comment in
                CommentContainerView(comment: comment).environmentObject(userViewModel)
            }
        }
    }
}

extension ArticleView: AuthenticationFormProtocol{
    var formIsValid: Bool{
        return newCommentContent.count > 5
    }
}

struct ArticleView_Previews: PreviewProvider {
    static var previews: some View {
        
        ArticleView(article: Article.MOCK_ARTICLE)
    }
}

