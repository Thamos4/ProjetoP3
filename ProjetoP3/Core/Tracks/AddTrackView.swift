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
                            .padding(.top, 40)
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
                    
                    ButtonView(label: "Create Conference", isDisabled: !formIsValid){
                        Task {
                            try await trackViewModel.createTrack(name: name, description: description, conferenceId: conferenceId)
                           
                            dismiss()
                        }
                        
                    }
                                        
                }
                .padding(.horizontal)
        
                

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
