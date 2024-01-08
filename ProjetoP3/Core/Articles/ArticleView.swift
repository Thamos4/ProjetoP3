//
//  ArticleView.swift
//  ProjetoP3
//
//  Created by user243107 on 1/7/24.
//

//import SwiftUI
//
//struct ArticleView: View {
//    @State private var trackId = ""
//    @State private var author = ""
//    @State private var summary = ""
//    @StateObject private var viewModel = ArticlesViewModel()
//
//    @State private var isError = false
//
//    var body: some View {
//        VStack(spacing: 24){
//            InputView(imageName: "envelope",placeholder: "trackId", text: $trackId)
//                .autocapitalization(.none)
//
//            InputView(imageName: "envelope",placeholder: "Author",
//                      text: $author)
//                .autocapitalization(.none)
//
//            InputView(imageName: "envelope",placeholder: "Summary",
//                      text: $summary)
//                .autocapitalization(.none)
//
//        }
//        .padding(.horizontal)
//        .padding(.top, 12)
//        ButtonView(label: "Create Article", icon: "arrow.right", iconOnLeft: false, isDisabled: !formIsValid){
//            Task {
//                do{
//                    try await viewModel.createArticle(trackId: trackId, author: author, summary: summary)
//                }catch{
//                    self.isError = true
//                }
//
//            }
//        }
//        ButtonView(label: "Update Article", icon: "arrow.right", iconOnLeft: false, isDisabled: false){
//            Task {
//                do{
//                    try await viewModel.updateArticle(id: "Z6RDTsDOG5Y5cgNSKYLh" ,trackId: "updatedtrack", author: "updatedauthor", summary: "updatedsummary")
//                }catch{
//                    self.isError = true
//                }
//
//            }
//        }
//        ButtonView(label: "Delete Article", icon: "arrow.right", iconOnLeft: false, isDisabled: false){
//            Task {
//                do{
//                    try await viewModel.deleteArticle(id: "Z6RDTsDOG5Y5cgNSKYLh")
//                }catch{
//                    self.isError = true
//                }
//
//            }
//        }
//    }
//}
//
//
//extension ArticleView: AuthenticationFormProtocol {
//    var formIsValid: Bool {
//        return !trackId.isEmpty
//        && !author.isEmpty
//        && !summary.isEmpty
//    }
//
//}
//
//struct ArticleView_Previews: PreviewProvider {
//    static var previews: some View {
//        ArticleView()
//    }
//}

