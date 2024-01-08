//
//  ConferenceView.swift
//  ProjetoP3
//
//  Created by user243107 on 1/7/24.
//

import SwiftUI

struct ConferenceView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    let conference: Conference
    var body: some View {
        VStack {
            HStack{
                Image(systemName: "arrow.left")
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                HStack{
                    Image(systemName: "magnifyingglass")
                }.padding(.horizontal)
                
            }.padding(.horizontal)
            .padding(.bottom, 12)
            .font(.system(size: 20))
            
            HStack {
                Text(conference.name)
                    .font(.system(size: 25))
                    .padding(.top, 5)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                if let user = viewModel.currentUser, user.role == .admin {
                    HStack {
                        Image(systemName: "plus")
                        Text("Add Article")
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal)
                    .padding(.vertical,8)
                    .background(Color("TaskBG"))
                    .clipShape(Capsule())
                    
                }
            }.padding(.horizontal)
        }
    }
}

struct ConferenceView_Previews: PreviewProvider {
    static var previews: some View {
        let authViewModel = AuthViewModel()
        authViewModel.currentUser = User.MOCK_USER

        return ConferenceView(conference: Conference.MOCK_CONFERENCE)
            .environmentObject(authViewModel)
    }
}
