//
//  CommentContainerView.swift
//  ProjetoP3
//
//  Created by user243107 on 1/11/24.
//

import SwiftUI

struct CommentContainerView: View {
    @StateObject var commentViewModel = CommentViewModel()
    @EnvironmentObject var userViewModel: AuthViewModel
    @State private var profileImage: Image?
    
    let comment: articleComment
    var onDeleteComment: (()-> Void)?
    @State private var showAlert = false
    @State var user = User(id: "", fullname: "TEST", email: "", role: Role(rawValue: "User")!, birthdate: "", profileImagePath: "")
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10){
            HStack{
                if let image = profileImage {
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: 30, height: 30)
                        .cornerRadius(10)
                        .clipShape(Circle())
                } else {
                    Image(systemName: "person")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 30, height: 30)
                        .clipShape(Circle())
                        .padding(.trailing, 14)
                }
                Text(user.fullname)
                if let user = userViewModel.currentUser, user.role == .admin {
                    Button {
                        onDeleteComment?()
                        
                        Task {
                            try await commentViewModel.deleteComment(id:comment.id, articleId: comment.articleId)
                        }
                        self.showAlert = true
                    } label: {
                        Image(systemName: "trash")
                            .foregroundColor(Color(.red))
                            .font(.system(size: 13))
                    }
                }
            }
            Text(comment.content)
                .padding(.leading, 38)
        }
        .padding(.horizontal)
        .onAppear{
            Task {
                user = try await userViewModel.getUser(id: comment.userId)
                profileImage = try await userViewModel.loadImage(user: user)
            }
        }
    }
}

struct CommentContainerView_Previews: PreviewProvider {
    static var previews: some View {
        let userViewModel = AuthViewModel()
        
        userViewModel.currentUser = User.MOCK_USER
        
        return CommentContainerView(comment: articleComment.MOCK_COMMENT)
            .environmentObject(userViewModel)
   }
}
