//
//  AddArticleView.swift
//  ProjetoP3
//
//  Created by user243107 on 1/9/24.
//

import SwiftUI

struct AddArticleView: View {
    @State private var name = ""
    @State private var description = ""
    @State private var beginDate = Date()
    @State private var endDate = Date()
//    @State private var goHome = false
    @StateObject private var viewModel = ArticleViewModel()
    
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct AddArticleView_Previews: PreviewProvider {
    static var previews: some View {
        AddArticleView()
    }
}
