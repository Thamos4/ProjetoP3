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
    
    let comment: articleComment
    var onDeleteComment: (()-> Void)?
    @State private var showAlert = false
    @State var user = User(id: "", fullname: "TEST", email: "", role: Role(rawValue: "User")!, birthdate: "", profileImagePath: "")
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10){
            HStack{
                if let image = userViewModel.profileImage {
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: 40, height: 40)
                        .cornerRadius(10)
                        .clipShape(Circle())
                } else {
                    Image(systemName: "person")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 40, height: 40)
                        .clipShape(Circle())
                        .padding([.top, .trailing], 14)
                }
                Text(user.fullname)
                if let user = userViewModel.currentUser, user.role == .admin {
                    
                    Button {
                        self.showAlert = true
                    } label: {
                        Image(systemName: "trash")
                            .foregroundColor(Color(.red))
                            .font(.system(size: 13))
                    }.alert(isPresented: $showAlert) {
                        Alert(title: Text("Delete Comment?"),
                              message: Text("Do you really want to delete this comment? "),
                              primaryButton: .default(Text("Yes"), action:{
                            onDeleteComment?()
                            self.showAlert = false

                            Task {
                                                try await commentViewModel.deleteComment(id:comment.id, articleId: comment.articleId)
                                print("DEBUG: Selected comment: - ", comment.content)
                            }
                        }),
                              secondaryButton: .default(Text("No"), action:{
                            self.showAlert = false
                        }))
                    }
                    
                }
            }
            Text(comment.content)
        }
        .padding(20)
        .onAppear{
            Task {
                user = try await userViewModel.getUser(id: comment.userId)
                let uiImage = try await StoreManager.shared.getImage(userId: user.id, path: user.profileImagePath)
                userViewModel.profileImage = Image(uiImage: uiImage)
            }
        }
    }
}

//struct CommentContainerView_Previews: PreviewProvider {
//    static var previews: some View {
//        let userViewModel = AuthViewModel()
//        
//        userViewModel.currentUser = User.MOCK_USER
//        
//        return CommentContainerView(comment: articleComment.MOCK_COMMENT)
//            .environmentObject(userViewModel)
//    }
//}
