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
    @State private var filteredArticles: [Article] = []
    
    @State private var articles: [Article] = []
    @Environment(\.dismiss) var dismiss
    
    let conference: Conference
    
    
    func dateFromString(dateString: String, format: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = format
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
                return calendar.isDate(dateFromString(dateString: $0.startDate, format: "dd/MM/yyyy")!, inSameDayAs: currentDay)
            }
            
                .sorted { article1, article2 in
                    return dateFromString(dateString: article2.startHour, format: "HH:mm")! > dateFromString(dateString: article1.startHour, format: "HH:mm")!
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
                            NavigationLink(destination: ArticleSearchView(conference: conference)) {
                                Image(systemName: "magnifyingglass")
                                    .font(.title)
                            }
                            
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
                                ForEach(filteredArticles) { article in
                                    
                                    NavigationLink(destination: ArticleView(article: article)
                                        .navigationBarBackButtonHidden(true)
                                    ){
                                        ArticleContainerView(article: article)
                                    }
                                }
                            } else {
                                Text("No Available Articles")
                                    .font(.system(size: 25))
                                    .padding(.top, 5)
                                    .padding(.horizontal)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            
                        }
                        .padding(.horizontal, 5)
                        
                        Spacer()
                    }.padding(.horizontal)
                        .onChange(of: currentDay, perform: { newValue in
                            filterTodayArticles()
                        })
                }.onAppear(){
                    Task {
                        articles = try await articlesViewModel.getArticlesByConference(conferenceId: conference.id)
                        filterTodayArticles()
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
