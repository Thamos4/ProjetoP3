//
//  ArticleView.swift
//  ProjetoP3
//
//  Created by user243107 on 1/7/24.
//

import SwiftUI

struct ArticleView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @StateObject var articleViewModel = ArticleViewModel()
    let article: Article
   
    var body: some View {
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
            }
            Spacer()
        }
        .padding(.top, 12)
        .padding(.horizontal)
    }
}

struct ArticleView_Previews: PreviewProvider {
    static var previews: some View {
        
        ArticleView(article: Article.MOCK_ARTICLE)
    }
}

