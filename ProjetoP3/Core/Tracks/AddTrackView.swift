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
                
                HStack{
                    Spacer()
                    VStack(alignment: .center) {
                        Image(systemName: "arrow.left")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .onTapGesture {
                                dismiss()
                            }
                            .foregroundColor(.white)
                        
                        Text(name.isEmpty ? "New Track" : name)
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(Color.white)
                            .padding(.horizontal)
                            .padding(.top, 50)
                        Spacer()
                    }
                    .padding(.horizontal)
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
