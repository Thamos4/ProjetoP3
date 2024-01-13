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
        if let user = viewModel.currentUser {
        VStack(alignment: .leading){
                VStack {
                    HStack {
                        Image(systemName: "newspaper.fill")                .frame(width: 20, height: 20)
                            .foregroundColor(.white)
                        Text("\(article.title)")
                            .font(.headline)
                            .foregroundColor(Color(.white))
                            .bold()
                        
                        Spacer()
            
                        
                        HStack {
                            Image(systemName: "clock")                .frame(width: 20, height: 20)
                                .foregroundColor(.white)
                            Text("8:00")
                                .foregroundColor(Color(.white))
                        }

                    }.padding(.vertical, 6)
                    
                    VStack(alignment: .leading, spacing: 12){
                        
                        Text(article.summary)
                            .font(.system(size: 15))
                            .foregroundColor(Color(.white))
                        
                        Text("Track: Informática")
                            .font(.system(size: 15))
                            .foregroundColor(Color(.white))
                        
                        HStack {
                            HStack {
                                Image(systemName: "person.fill")               .font(.system(size: 15))
                                    .foregroundStyle(.secondary)
                                    .foregroundColor(.white)
                                Text(article.author)
                                    .font(.system(size: 14))
                                    .foregroundStyle(.secondary)
                                    .foregroundColor(Color(.white))
                            }
                            
                            Spacer()
                            
                            HStack {
                                Image(systemName: "door.left.hand.closed")               .font(.system(size: 15))
                                    .foregroundStyle(.secondary)
                                    .foregroundColor(.white)
                                Text(article.room)
                                    .font(.system(size: 14))
                                    .foregroundStyle(.secondary)
                                    .foregroundColor(Color(.white))
                            }
                        }.padding(.top, 6)
       
                    }.frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.top, 6)

                }
            
            if user.role == .admin {
                HStack{
                    Image(systemName: "pencil")
                        .foregroundColor(Color(.white))
                        .font(.system(size: 13))
                    
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
                .padding(.top, 1)
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
