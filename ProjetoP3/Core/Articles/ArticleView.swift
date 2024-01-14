//
//  ArticleView.swift
//  ProjetoP3
//
//  Created by user243107 on 1/7/24.
//

import SwiftUI

struct ArticleView: View {
    @State var progress: CGFloat = 0
    
    @EnvironmentObject var userViewModel: AuthViewModel
    @StateObject var articleViewModel = ArticleViewModel()
    @StateObject var commentViewModel = CommentViewModel()
    @State private var currentCommentList: [articleComment] = []
    @State private var newCommentContent: String = ""
    
    @Environment(\.dismiss) var dismiss
    
    let article: Article
   
    var body: some View {
        NavigationStack{
            VStack {
                VStack{
                    HStack {

                        Image(systemName: "arrow.left")
                        .foregroundColor(.white)
                        .font(.system(size: 22))
                        .onTapGesture {
                            dismiss()
                        }
                        Spacer()
                        
                        Text(article.title)
                            .font(.largeTitle)
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        Image(systemName: "pencil")
                            .font(.system(size: 32))
                            .foregroundColor(.white)
                    }
                    .padding(.horizontal)
                    .padding(.top, 60)
                    HStack {
                        Image(systemName: "person.fill")
                            .frame(width: 20, height: 20)
                        Text(article.author)
                            .font(.system(size: 18))
                        Spacer()
                        Image(systemName: "door.right.hand.closed")
                            .frame(width: 20, height: 20)
                        Text(article.room)
                            .font(.system(size: 18))
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 40)
                    .foregroundColor(.white)
                   
                        HStack {
                            Image(systemName: "doc.text.fill")
                                .frame(width: 30, height: 30)
                                .padding(.leading, 15)
                            Text(article.summary)
                                .font(.system(size: 14))
                                .padding()
                        }
                        .background(.white)
                        .clipShape(Capsule())
                        .padding(.horizontal, 10)
                        .padding(.bottom, 40)
                   
                }
                .background(Color("TaskBG"))
                .ignoresSafeArea()
                .onAppear{
                    Task {
                        try await commentViewModel.getCommentsByArticleId(articleId:article.id)
                        currentCommentList = commentViewModel.comments
                    }
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
                }.padding(.horizontal)
            }
            
            
            
            
            ForEach(currentCommentList){ comment in
                CommentContainerView(comment: comment).environmentObject(userViewModel)
            }
        }.toolbar(.hidden, for: .tabBar)
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

