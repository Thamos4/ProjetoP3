//
//  AddArticleView.swift
//  ProjetoP3
//
//  Created by Catarina Vasconcelos on 12/01/2024.
//

import SwiftUI

struct AddArticleView: View {
    let conferenceId: String
    let startDay: Date
    @EnvironmentObject var viewModel: AuthViewModel
    @StateObject var articleViewModel = ArticleViewModel()
    @StateObject var trackViewModel = TrackViewModel()
    
    @State private var title = ""
    @State private var author = ""
    @State private var summary = ""
    @State private var trackId = ""
    //Default time 9:30am
    @State private var hour: Date = {
        var calendar = Calendar.current
        return calendar.date(bySettingHour: 8, minute: 30, second: 0, of: Date())!
    }()
    
    @State private var selectedRoom: String = ""
    @State private var roomsList = ArticleRoom.allCases.map( { $0.rawValue } )
    	
    @State private var selectedTrack: String = ""
    @State private var trackOptions: [String] = []
    
    @Environment(\.dismiss) var dismiss
    
    func formatDate(date: Date, format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: date)
    }
    
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
                        
                        Text(title.isEmpty ? "New Article" : title)
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(Color.white)
                            .padding(.horizontal)
                            .padding(.top, 40)
                        Spacer()
                    }
                    Spacer()
                }
                
                VStack(spacing: 20){
                    InputView(imageName: "doc.fill", placeholder: "Article", text: $title)
                    
                    InputView(imageName: "person", placeholder: "Author", text: $author)
                    
                    HStack {
                        HStack {
                            Image(systemName: "door.right.hand.closed")
                                .frame(width: 20, height: 20)
                            Text("Room")
                                .font(.system(size: 14))
                        }
                        
                        DropdownView(hint: "Select", options: roomsList, selection: $selectedRoom)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }.zIndex(1001)
                
                    HStack {
                        HStack {
                            Image(systemName: "globe")
                                .frame(width: 20, height: 20)
                            Text("Track")
                                .font(.system(size: 14))
                        }
                    
                        DropdownView(hint: "Select", options: trackOptions, selection: $selectedTrack)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }.zIndex(1000)
                        
                
                    HStack {
                        Image(systemName: "clock")
                            .frame(width: 20, height: 20)
                        DatePicker("Start Hour", selection: $hour, displayedComponents: .hourAndMinute)
                    }
                    .font(.system(size: 14))
              
      
                    InputView(imageName: "pencil", placeholder: "Summary", text: $summary)
                    
                    ButtonView(label: "Create Article", isDisabled: !formIsValid){
                        Task {
                            try await articleViewModel.createArticle(
                                trackId: trackId,
                                conferenceId: conferenceId,
                                title: title,
                                author: author,
                                summary: summary,
                                room: selectedRoom,
                                startDate: formatDate(date: startDay, format: "dd/MM/yyyy"),
                                startHour: formatDate(date: hour, format: "HH:mm"))
                            
                            
                            dismiss()
                        }
                    }
                    
                }
                .padding(.top, 100)
            }
            .onAppear{
                Task{
                    try await trackViewModel.getTracksByConferenceId(conferenceId: conferenceId)
                    trackOptions = trackViewModel.tracks.map { track in track.name }
                }
            }
            .onChange(of: selectedTrack, perform: {
                newValue in
                if let foundTrack = trackViewModel.tracks.first(where: { $0.name == newValue }) {
                    trackId = foundTrack.id
                }
            })
            .padding(.horizontal, 18)

        }.toolbar(.hidden, for: .tabBar)
    }
    
}

extension AddArticleView: AuthenticationFormProtocol {
    var formIsValid: Bool {
        return !title.isEmpty
        && !author.isEmpty
        && !selectedRoom.isEmpty
        && !selectedTrack.isEmpty
        && !summary.isEmpty
        && !trackId.isEmpty
        && !selectedTrack.isEmpty
    }
    
}

struct AddArticleView_Previews: PreviewProvider {
    static var previews: some View {
        let authViewModel = AuthViewModel()

        return AddArticleView(conferenceId: Conference.MOCK_CONFERENCE.id, startDay: Date())
            .environmentObject(authViewModel)
        
    }
}
