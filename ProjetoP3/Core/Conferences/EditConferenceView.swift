//
//  AddConferenceView.swift
//  ProjetoP3
//
//  Created by user243107 on 1/7/24.
//

import SwiftUI

struct EditConferenceView: View {
    let conference: Conference
    @State private var name: String
    @State private var description: String
    @State private var beginDate: Date
    @State private var endDate: Date
    @State private var goHome = false
    @StateObject private var viewModel = ConferenceViewModel()
    @Environment(\.dismiss) var dismiss
    
    init(conference: Conference) {
        self.conference = conference
        _name = State(initialValue: conference.name)
        _description = State(initialValue: conference.description)
        _beginDate = State(initialValue: Date())
        _endDate = State(initialValue: Date())
        if let formattedBeginDate = dateFromFormattedString(conference.beginDate){
            _beginDate = State(initialValue: formattedBeginDate)
        }
        
        if let formattedEndDate = dateFromFormattedString(conference.endDate){
            _endDate = State(initialValue: formattedEndDate)
        }
        
        
    }
    
    func dateFromFormattedString(_ formattedString: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter.date(from: formattedString)
    }
    
    func formattedDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
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
                
                HStack {
                    Spacer()
                    VStack(alignment: .center) {
                        Image(systemName: "arrow.left")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .onTapGesture {
                                dismiss()
                            }
                            .foregroundColor(.white)
                        
                        Text(name.isEmpty ? "Edit Conference" : name)
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
                    InputView(imageName: "pencil", placeholder: "Task Name", text: $name)
                        .autocapitalization(.none)
                    
                    DatePicker("Begin Date", selection: $beginDate, displayedComponents: .date)
                    
                    DatePicker("End Date", selection: $endDate, displayedComponents: .date)
                    
                    TextField("Description", text: $description,  axis: .vertical)
                        .lineLimit(1...5)
                    
                    
                    ButtonView(label: "Edit Conference", isDisabled: !formIsValid){
                        Task {
                            try await viewModel.updateConference(id:conference.id, name: name, beginDate: formattedDate(date: beginDate), endDate: formattedDate(date: endDate), description: description)
                            
                            dismiss()
                        }
                        
                    }

                    
                }
                .padding(.horizontal)
                .padding(.top, 75)

            }
        }.toolbar(.hidden, for: .tabBar)
    }
}

extension EditConferenceView: AuthenticationFormProtocol {
    var formIsValid: Bool {
        return !name.isEmpty
                && !description.isEmpty
                && beginDate <= endDate
    }

}


struct EditConferenceView_Previews: PreviewProvider {
    static var previews: some View {
        AddConferenceView()
    }
}
