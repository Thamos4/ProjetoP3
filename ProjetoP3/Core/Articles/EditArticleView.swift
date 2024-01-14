//
//  AddArticleView.swift
//  ProjetoP3
//
//  Created by Catarina Vasconcelos on 12/01/2024.
//

import SwiftUI

struct EditArticleView: View {
    @Binding var article: Article
    @State var startDay: Date
    @EnvironmentObject var viewModel: AuthViewModel
    @StateObject var articleViewModel = ArticleViewModel()
    @StateObject var trackViewModel = TrackViewModel()
    
    @State private var title: String
    @State private var author: String
    @State private var summary: String
    @State private var trackId: String
    @State private var hour: Date
    
    
    @State private var selectedRoom: String = ""
    @State private var roomsList = ArticleRoom.allCases.map( { $0.rawValue } )
        
    @State private var selectedTrack: String = ""
    @State private var trackOptions: [String] = []
    
    @Environment(\.dismiss) var dismiss
    
    init(article: Binding<Article>){
        self._article = article
        self._hour = State(initialValue: Date())
        self._startDay = State(initialValue: Date())
        self._title = State(initialValue: "")
        self._author = State(initialValue: "")
        self._summary = State(initialValue: "")
        self._trackId = State(initialValue: "")
        
        
        self._title = State(initialValue: self.article.title)
        self._author = State(initialValue: self.article.author)
        self._summary = State(initialValue: self.article.summary)
        self._trackId = State(initialValue: self.article.trackId)
        
        
        if let formattedHour = dateFromFormattedTimeString(self.article.startHour){
            self._hour = State(initialValue: formattedHour)
        }
        
        if let formattedDate = dateFromFormattedString(self.article.startDate){
            self._startDay = State(initialValue: formattedDate)
        }
    }
    
    func formatDate(date: Date, format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: date)
    }
    
    func dateFromFormattedString(_ formattedString: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter.date(from: formattedString)
    }
    
    func dateFromFormattedTimeString(_ timeString: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"

        if let date = formatter.date(from: timeString) {
            return date
        } else {
            return nil
        }
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
                    
                    ButtonView(label: "Edit Article", isDisabled: !formIsValid){
                        Task {
                            try await articleViewModel.updateArticle(
                                id: article.id, trackId: trackId,
                                conferenceId: article.conferenceId,
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
                    try await trackViewModel.getTracksByConferenceId(conferenceId: article.conferenceId)
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

extension EditArticleView: AuthenticationFormProtocol {
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

struct EditArticleView_Previews: PreviewProvider {
    static var previews: some View {
        let authViewModel = AuthViewModel()

        return AddArticleView(conferenceId: Conference.MOCK_CONFERENCE.id, startDay: Date())
            .environmentObject(authViewModel)
        
    }
}
