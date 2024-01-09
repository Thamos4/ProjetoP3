//
//  AddTrackView.swift
//  ProjetoP3
//
//  Created by user243107 on 1/9/24.
//

import SwiftUI

struct AddTrackView: View {
    @State private var name = ""
    @State private var description = ""
    let conferenceId: String
//    @State private var goHome = false
    @StateObject private var viewModel = TrackViewModel()
    
    var body: some View {
        VStack(spacing: 40){
            InputView(imageName: "pencil", placeholder: "Task Name", text: $name)
                .autocapitalization(.none)
            
            TextField("Description", text: $description,  axis: .vertical)
                .lineLimit(1...5)
            
            Button{
                Task {
                    try await viewModel.createTrack(name: name, description: description, conferenceId: conferenceId)
                    
//                    self.goHome = true //go back instead
                }
            }label: {
                Text("Create Track")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(width: 340, height: 50)
                    .background(Color("TaskBG"))
                    .clipShape(Capsule())
                    .padding()
            }
            .disabled(!formIsValid)
            .opacity(!formIsValid ? 0.5: 1.0)
            
        }
        .padding(.horizontal)
        .padding(.top, 75)
    }
}

extension AddTrackView: AuthenticationFormProtocol {
    var formIsValid: Bool {
        return !name.isEmpty
                && !description.isEmpty
    }

}

struct AddTrackView_Previews: PreviewProvider {
    static var previews: some View {
        AddTrackView(conferenceId:"test")
    }
}
