//
//  ConferenceContainerView.swift
//  ProjetoP3
//
//  Created by user243107 on 1/7/24.
//

import SwiftUI

struct ConferenceContainerView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @StateObject var conferenceViewModel = ConferenceViewModel()
    let conference: Conference
    @State private var showAlert = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15){
                VStack {
                    HStack {
                        Text("From: \(conference.beginDate)")
                            .font(.caption)
                            .foregroundColor(Color(.white))
                            .clipShape(Capsule())
                        
                        Spacer()
                        
                        Text("To: \(conference.endDate)")
                            .font(.caption)
                            .foregroundColor(Color(.white))
                            .clipShape(Capsule())
                        
                    }.padding(.vertical, 6)
                    
                    VStack(alignment: .leading, spacing: 12){
                        Text(conference.name)
                            .font(.title3)
                            .foregroundColor(Color(.white))
                            .bold()
                        
                        Text(conference.description)
                            .font(.headline)
                            .foregroundColor(Color(.white))
                            .bold()
                    }.frame(maxWidth: .infinity, alignment: .leading)
                }
  
            HStack{
                if let user = viewModel.currentUser, user.role == .admin {
                    NavigationLink(destination: EditConferenceView(conference: conference)){
                        Image(systemName: "pencil")
                            .foregroundColor(Color(.white))
                            .font(.system(size: 13))
                    }
                    
                    Button {
                        self.showAlert = true
                    } label: {
                        Image(systemName: "trash")
                            .foregroundColor(Color(.red))
                            .font(.system(size: 13))
                    }.alert(isPresented: $showAlert) {
                        Alert(title: Text("Delete Conference?"),
                              message: Text("Do you really want to delete this conference? "),
                              primaryButton: .default(Text("Yes"), action:{
                            self.showAlert = false
                            
                            Task {
                                try await conferenceViewModel.deleteConference(id: conference.id)
                            }
                        }),
                              secondaryButton: .default(Text("No"), action:{
                            
                            self.showAlert = false
                        }))
                    }
                    
                }
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

struct ConferenceContainerView_Previews: PreviewProvider {
    static var previews: some View {
        let authViewModel = AuthViewModel()
        authViewModel.currentUser = User.MOCK_USER
        
        return ConferenceContainerView(conference: Conference.MOCK_CONFERENCE)
            .environmentObject(authViewModel)
    }
}
