//
//  ArticleSearchView.swift
//  ProjetoP3
//
//  Created by user243107 on 1/9/24.
//
import Foundation
import SwiftUI

struct ArticleSearchView: View {
    let conference: Conference
    @State private var search = ""
    @State private var searchedArticles: [Article] = []
    @StateObject private var viewModel = ArticleViewModel()
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack{
            VStack{
                Image(systemName: "arrow.left")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .onTapGesture {
                        dismiss()
                    }
                    .padding(.bottom, 18)
                
                InputView(imageName: "magnifyingglass", placeholder: "Search", text: $search)
                    .onChange(of: search) { newSearch in
                        Task{
                            searchedArticles = viewModel.articles
                            if newSearch != "" {
                                try await viewModel.searchArticle(articleTitle: newSearch)
                                searchedArticles = viewModel.articles
                            }
                        }
                    }
                ScrollView{
                    VStack{
                        if(searchedArticles.count > 0) {
                            ForEach(searchedArticles) { article in
                               ArticleContainerView(article: article){
                                   Task {
                                       searchedArticles = try await viewModel.getArticlesByConference(conferenceId: conference.id)
                                   }
                               }
                            }
                        }else if(viewModel.articles.count > 0){
                            Text("No Articles match your search")
                                .font(.system(size: 25))
                                .padding(.top, 5)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        } else {
                            Text("No Available Articles")
                                .font(.system(size: 25))
                                .padding(.top, 5)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                }
            }
        }
        .padding(.horizontal)
        .onAppear{
            Task {
                searchedArticles = try await viewModel.getArticlesByConference(conferenceId: conference.id)
                
            }
        }
    }
}

//struct ArticleSearchView_Previews: PreviewProvider {
//    static var previews: some View {
//
//        ArticleSearchView()
//    }
//}
