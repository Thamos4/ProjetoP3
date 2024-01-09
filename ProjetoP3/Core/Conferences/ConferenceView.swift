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
    @State private var conferenceDays: [Date] = []
    @State private var currentDay: Date = Date()
    let conference: Conference
    
    func isToday(date: Date) -> Bool {
        let calendar = Calendar.current
        
        return calendar.isDate(currentDay, inSameDayAs: date)
    }
   
    var body: some View {
        VStack {
            HStack{
                NavigationLink(destination: Home()
                    .navigationBarBackButtonHidden(true)) {
                    Image(systemName: "arrow.left")
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }.foregroundColor(.black)
                
                Image(systemName: "magnifyingglass")
               
                
            }.padding(.horizontal)
            .padding(.bottom, 12)
            .font(.system(size: 16))
            
            HStack {
                Text(conference.name)
                    .font(.title)
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
                    .font(.system(size: 14))
                }
            }.padding(.horizontal)
                .padding(.top, 12)
            
        
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10){
                    ForEach(conferenceDays, id: \.self){ day in
                        
                        VStack(spacing: 10) {
                            Text(conferenceViewModel.extractDate(date: day, format: "DD"))
                                .font(.system(size: 15))
                                .fontWeight(.semibold)
                            
                            Text(conferenceViewModel.extractDate(date: day, format: "MMM"))
                                .font(.system(size: 14))
                            
                            Circle()
                                .fill(.white)
                                .frame(width: 8, height: 8)
                                .opacity(isToday(date: day) ? 1 : 0)
                            
                        }
                        .foregroundColor(.white)
                        .frame(width: 45, height: 90)
                        .background(
                            ZStack{
                                Capsule().fill(.black)
                            }
                        )
                    }
                    
                }.onAppear {
                    self.conferenceDays = conferenceViewModel.datesInRange(startDate: conference.beginDate, endDate: conference.endDate)
                }.padding(.top, 24)
                    .padding(.horizontal)
            }
            
            Spacer()
        }.padding(.top, 12)
        .padding(.horizontal)
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
