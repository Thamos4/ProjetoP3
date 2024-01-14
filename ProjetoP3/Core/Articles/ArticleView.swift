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
    
    @State var article: Article
    
    
    func dateFromString(dateString: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy HH:mm:ss"
        formatter.locale = Locale(identifier: "en_US_POSIX") // Set locale to ensure correct date parsing
        
        if let date = formatter.date(from: dateString) {
            return date
        } else {
            return nil
        }
    }
    
    func filterCommentsByDate()  {
        currentCommentList = currentCommentList.sorted {
            comment1, comment2 in
            return dateFromString(dateString: comment1.created_at)! < dateFromString(dateString: comment2.created_at)!
        }
        
    }
   
    var body: some View {
        NavigationStack{
            VStack {
                VStack{
                    HStack {
                        Image(systemName: "arrow.left")
                        .foregroundColor(.white)
                        .onTapGesture {
                            dismiss()
                        }
                        Spacer()
                        
                        Text(article.title)
                            .font(.largeTitle)
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        NavigationLink(destination: EditArticleView(article: $article)
                            .navigationBarBackButtonHidden(true)){
                            Image(systemName: "pencil")
                                .font(.system(size: 18))
                                .foregroundColor(.white)
                        }
                        
                    }
                    .padding(.horizontal)
                    .padding(.top, 15)
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
                    .foregroundColor(.white)
                   
                    VStack {
                        HStack {
                                Image(systemName: "doc.text.fill")
                                    .padding(.leading)
                                
                                Text(article.summary)
                                    .font(.system(size: 14))
                                    .padding(.trailing, 12)
                                    .padding(.leading, 0)
                                    .padding(.vertical, 12)
                            }
                            .background(.white)
                            .clipShape(Capsule())
                            .padding(.top, 15)
                    }.padding(.bottom, 30)

                   
                }
                .background(Color("TaskBG"))
                .onAppear{
                    Task {
                        try await commentViewModel.getCommentsByArticleId(articleId:article.id)
                        currentCommentList = commentViewModel.comments
                        
                        filterCommentsByDate()

                    }
                }
                
                Spacer()
                
                ScrollView{
                    VStack(alignment: .leading){
                        ForEach(currentCommentList.reversed()){ comment in
                            CommentContainerView(comment: comment) {
                                Task{
                                    try await commentViewModel.getCommentsByArticleId(articleId:comment.articleId)
                                    currentCommentList = commentViewModel.comments 
                                    
                                }
                            }

                        }
                        .environmentObject(userViewModel)
                    }.frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.top, 12)
                }
                
        
                HStack{
                    InputView(imageName: "pencil", placeholder: "Write a question here", text: $newCommentContent)
                    Button{
                        Task {
                            
                            try await currentCommentList.append(commentViewModel.addComment(articleId: article.id, userId: userViewModel.currentUser!.id,content: newCommentContent))
                            newCommentContent = ""
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
        }.toolbar(.hidden, for: .tabBar)
    }
}

extension ArticleView: AuthenticationFormProtocol{
    var formIsValid: Bool{
        return !newCommentContent.isEmpty
    }
}

struct ArticleView_Previews: PreviewProvider {
    static var previews: some View {
        
        let authViewModel = AuthViewModel()
        
        ArticleView(article: Article.MOCK_ARTICLE)
            .environmentObject(authViewModel)
    }
}

