//
//  ConferenceView.swift
//  ProjetoP3
//
//  Created by user243107 on 1/7/24.
//

import SwiftUI

struct ConferenceView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @StateObject var conferenceViewModel = ConferenceViewModel()
    @StateObject var articlesViewModel = ArticleViewModel()
    
    @State private var currentDay: Date = Date()
    @State private var filteredArticles: [Article]?
    
    @State private var articles: [Article] = []
    
    @Environment(\.dismiss) var dismiss
    
    let conference: Conference
    
    func isToday(date: Date) -> Bool {
        let calendar = Calendar.current
        
        return calendar.isDate(currentDay, inSameDayAs: date)
    }
    
    func dateFromString(dateString: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        formatter.locale = Locale(identifier: "en_US_POSIX") // Set locale to ensure correct date parsing
        
        if let date = formatter.date(from: dateString) {
            return date
        } else {
            return nil
        }
    }
    
    func filterTodayArticles(){
        DispatchQueue.global(qos: .userInteractive).async {
            let calendar = Calendar.current
            
            let filtered = self.articles.filter{
                return calendar.isDate(dateFromString(dateString: $0.startDate)!, inSameDayAs: Date())
            }
            
            DispatchQueue.main.async {
                withAnimation {
                    self.filteredArticles = filtered
                }
            }
        }
    }
    
    var body: some View {
        if let user = viewModel.currentUser {
            ScrollView(.vertical, showsIndicators: false) {
               NavigationStack {
                    VStack {
                        HStack{
                            Image(systemName: "arrow.left")
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .onTapGesture {
                                    dismiss()
                                }
                            
                            Image(systemName: "magnifyingglass")
                            
                            
                        }.padding(.horizontal)
                            .padding(.bottom, 12)
                            .font(.system(size: 16))
                        
                        HStack {
                            Text(conference.name)
                                .font(.title)
                                .padding(.top, 5)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            if user.role == .admin {
                                NavigationButton(label: "Add Track", icon: "plus", destination: AddTrackView(conferenceId: conference.id))
                            }
                        }
                        .padding(.top, 12)
                        
                        //MARK: Conference days
                        ConferenceDaysView(beginDate: conference.beginDate, endDate: conference.endDate, currentDay: $currentDay)
                        
                        VStack(spacing: 10) {
                            //MARK: Articles
                            if user.role == .admin {
                                NavigationButton(label: "Add Article", icon: "plus", destination: AddArticleView(
                                    conferenceId: conference.id,
                                    startDay: currentDay))
                                .frame(maxWidth: .infinity, alignment: .trailing)
                                .padding(.top, 12)
                                
                            }
                            
                        }
                        
                        LazyVStack(spacing: 18){
                            if !articles.isEmpty {
                                ForEach(articles) { article in
                                    ArticleContainerView(article: article)
                                }
                            } else {
                                Text("No Available Articles")
                                    .font(.system(size: 25))
                                    .padding(.top, 5)
                                    .padding(.horizontal)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            
                        }
                        
                        Spacer()
                    }.padding(.horizontal, 18)
                }.onAppear(){
                    Task {
                        articles = try await articlesViewModel.getArticlesByConference(conferenceId: conference.id)
                    }
                }

            }
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
