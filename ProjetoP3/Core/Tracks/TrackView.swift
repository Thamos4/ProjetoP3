//
//  TrackView.swift
//  ProjetoP3
//
//  Created by user243107 on 1/7/24.
//

import SwiftUI

struct TrackView: View {
    @State private var name = ""
    @State private var description = ""
    @State private var goHome = false
    @StateObject var trackViewModel = TrackViewModel()
    @Environment(\.dismiss) var dismiss
    
    let conferenceId: String
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color("HomeBG")
                .ignoresSafeArea()
                //header
                Ellipse()
                .fill(Color("TaskBG"))
                .frame(width: geometry.size.width * 2.0, height: geometry.size.height * 0.50)
                .position(x: geometry.size.width / 2.35, y: geometry.size.height * 0.1)
                .shadow(radius: 3)
                .edgesIgnoringSafeArea(.all)
                
                HStack {
                    Spacer()
                    VStack(alignment: .leading) {
                        Text("New Track")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(Color.white)
                            .padding(.trailing)
                        Spacer()
                    }
                    .padding(.leading, 25)
                    .padding(.top, 75)
                    Spacer()
                }
                VStack(spacing: 40){
                    InputView(imageName: "pencil", placeholder: "Track Name", text: $name)
                        .autocapitalization(.none)
            
                    
                    TextField("Description", text: $description,  axis: .vertical)
                        .lineLimit(1...5)
                    
                    Button{
                        Task {
                            try await trackViewModel.createTrack(name: name, description: description, conferenceId: conferenceId)
                           
                            dismiss()
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
                .padding(.top, 5)
        
                

            }
        }.toolbar(.hidden, for: .tabBar)
    }
}
                  
          
extension TrackView: AuthenticationFormProtocol {
    var formIsValid: Bool {
        return !name.isEmpty
        && !description.isEmpty
    }
    
}

struct TrackView_Previews: PreviewProvider {
    static var previews: some View {
        TrackView(conferenceId: NSUUID().uuidString)
    }
}
