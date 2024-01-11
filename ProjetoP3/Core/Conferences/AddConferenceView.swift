//
//  AddConferenceView.swift
//  ProjetoP3
//
//  Created by user243107 on 1/7/24.
//

import SwiftUI

struct AddConferenceView: View {
    @State private var name = ""
    @State private var description = ""
    @State private var beginDate = Date()
    @State private var endDate = Date()
    @State private var goHome = false
    @StateObject private var viewModel = ConferenceViewModel()
    @Environment(\.dismiss) var dismiss
    
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
                        
                        Text(name.isEmpty ? "New Conference" : name)
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
                    
                    
                    ButtonView(label: "Create Conference", isDisabled: !formIsValid){
                        Task {
                            try await viewModel.createConference(name: name, beginDate: formattedDate(date: beginDate),
                                                                 endDate: formattedDate(date: endDate),
                                                                 description: description)
                            
                            self.goHome = true
                        }
                        
                    }

                    
                }
                .padding(.horizontal)
                .padding(.top, 75)
                .navigationDestination(isPresented: $goHome) {
                    Home()
                }
        
                

            }
        }.toolbar(.hidden, for: .tabBar)
    }
}

extension AddConferenceView: AuthenticationFormProtocol {
    var formIsValid: Bool {
        return !name.isEmpty
                && !description.isEmpty
                && beginDate <= endDate
    }

}


struct AddConferenceView_Previews: PreviewProvider {
    static var previews: some View {
        AddConferenceView()
    }
}
