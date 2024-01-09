//
//  ArticleSearchView.swift
//  ProjetoP3
//
//  Created by user243107 on 1/9/24.
//
import Foundation
import SwiftUI

struct ArticleSearchView: View {
    @State private var search = ""
    @State private var starterArticles: [Article] = []
    @StateObject private var viewModel = ArticleViewModel()
    var body: some View {
        NavigationStack{
            VStack{
                InputView(imageName: "magnifyingglass", placeholder: "Search", text: $search)
                    .onChange(of: search) { newSearch in
                        Task {
                            do{
                                try await viewModel.searchArticle(articleName: newSearch, articlesList: starterArticles)
                            } catch {
                                print("Oopsie made searching for articles ;-;")
                            }
                        }
                    }
                ScrollView{
                    VStack{
                        if (search == "" && starterArticles.count > 0){
                            ForEach(starterArticles) { article in
                                ArticleContainerView(article: article)
                            }
                        }else if(viewModel.articles.count > 0) {
                            ForEach(viewModel.articles) { article in
                               ArticleContainerView(article: article)
                            }
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
        .onAppear{
            print("VIEW APPEARED")
            Task {
                print("ENTERED TASK")
                try await viewModel.getAllArticles()
                print("EXECUTED TRY AWAIT")
                starterArticles = viewModel.articles
                
            }
        }
    }
}

struct ArticleSearchView_Previews: PreviewProvider {
    static var previews: some View {
        
        ArticleSearchView()
    }
}
