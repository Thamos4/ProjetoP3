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
    @StateObject private var viewModel = ArticleViewModel()
    var body: some View {
        VStack{
            InputView(imageName: "magnifyingglass", placeholder: "Search", text: $search)
            
        }
    }
}

struct ArticleSearchView_Previews: PreviewProvider {
    static var previews: some View {
        ArticleSearchView()
    }
}
