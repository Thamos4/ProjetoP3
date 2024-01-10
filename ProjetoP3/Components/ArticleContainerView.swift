//
//  ArticleContainerView.swift
//  ProjetoP3
//
//  Created by user243107 on 1/9/24.
//

import SwiftUI

struct ArticleContainerView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @StateObject var articleViewModel = ArticleViewModel()
    let article: Article
    @State private var showAlert = false
    var body: some View {
        VStack(alignment: .leading, spacing: 15){
            HStack {
                Text(article.title)
                    .font(.title3)
                    .foregroundColor(Color(.white))
                    .bold()
                
                Text(article.author)
                    .font(.headline)
                    .foregroundColor(Color(.white))
                    .bold()
                
                Text(article.summary)
                    .font(.headline)
                    .foregroundColor(Color(.white))
                    .bold()
                HStack{
                    
                    if let user = viewModel.currentUser, user.role == .admin {
                        Button {
                            print("Lol123")
                        } label: {
                            Image(systemName: "pencil")
                                .foregroundColor(Color(.red))
                                .font(.system(size: 13))
                        }
                        
                        Button {
                            self.showAlert = true
                        } label: {
                            Image(systemName: "trash")
                                .foregroundColor(Color(.red))
                                .font(.system(size: 13))
                        }.alert(isPresented: $showAlert) {
                            Alert(title: Text("Delete Article?"),
                                  message: Text("Do you really want to delete this article? "),
                                  primaryButton: .default(Text("Yes"), action:{
                                self.showAlert = false
                                
                                Task {
                                    try await articleViewModel.deleteArticle(id: article.id)
                                }
                            }),
                                  secondaryButton: .default(Text("No"), action:{
                                
                                self.showAlert = false
                            }))
                        }
                        
                    }
                }
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color("TaskBG"))
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .padding()
            .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2)
            
            
        }
    }
}

struct ArticleContainerView_Previews: PreviewProvider {
    static var previews: some View {
        let authViewModel = AuthViewModel()
        authViewModel.currentUser = User.MOCK_USER
        
        return ArticleContainerView(article: Article.MOCK_ARTICLE)
            .environmentObject(authViewModel)
    }
}
