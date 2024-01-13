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
    
    @State private var currentDay: Date = Date()
    
    @Environment(\.dismiss) var dismiss
    
    let conference: Conference
    
    func isToday(date: Date) -> Bool {
        let calendar = Calendar.current
        
        return calendar.isDate(currentDay, inSameDayAs: date)
    }
    
    var body: some View {
        if let user = viewModel.currentUser {
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
                   

                        
                    Spacer()
                }.padding(.horizontal, 18)
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
