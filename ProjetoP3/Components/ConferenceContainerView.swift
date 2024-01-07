//
//  ConferenceContainerView.swift
//  ProjetoP3
//
//  Created by user243107 on 1/7/24.
//

import SwiftUI

struct ConferenceContainerView: View {
    let conference: Conference
    var body: some View {
        VStack(alignment: .leading, spacing: 15){
            HStack {
                Text("From:\(conference.beginDate)")
                    .font(.caption)
                    .padding(.vertical, 6)
                    .background(.black.opacity(0.1))
                    .foregroundColor(Color(.white))
                    .clipShape(Capsule())
                
                Spacer()
                
                Text("To:\(conference.endDate)")
                    .font(.caption)
                    .padding(.vertical, 6)
                    .background(.black.opacity(0.1))
                    .foregroundColor(Color(.white))
                    .clipShape(Capsule())
                
            }
            Text(conference.name)
                .font(.title3)
                .foregroundColor(Color(.white))
                .bold()
            
            Text(conference.description)
                .font(.headline)
                .foregroundColor(Color(.white))
                .bold()

            
            HStack{
                Image(systemName: "globe")
                .foregroundColor(Color(.white))
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color("TaskBG"))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .padding()
        .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2)

        
    }
}

struct ConferenceContainerView_Previews: PreviewProvider {
    static var previews: some View {
        ConferenceContainerView(conference: Conference.MOCK_CONFERENCE)
    }
}
