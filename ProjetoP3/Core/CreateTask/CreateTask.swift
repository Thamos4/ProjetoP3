//
//  LoginView.swift
//  ProjetoP3
//
//  Created by user243107 on 12/14/23.
//

import SwiftUI

struct CreateTask: View {
    let title: LocalizedStringKey
    let subtitle: LocalizedStringKey
    var bgColor: Color
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                //header
                Ellipse()
                .fill(self.bgColor)
                .frame(width: geometry.size.width * 2.4, height: geometry.size.height * 0.90)
                .position(x: geometry.size.width / 2.35, y: geometry.size.height * 0.1)
                .shadow(radius: 3)
                .edgesIgnoringSafeArea(.all)
                
                HStack {
                    VStack(alignment: .leading) {
                        Text(self.title)
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(Color.white)
                        Spacer()
                        Text("self.subtitle")
                            .font(.subheadline)
                            .fontWeight(.regular)
                            .foregroundColor(Color.black)
                        Spacer()
                        Spacer()
                    }
                    .padding(.leading, 25)
                    .padding(.top, 30)
                    Spacer()
                }
                
            }
        }
    }
}


struct CreateTask_Previews: PreviewProvider {
    static var previews: some View {
        CreateTask(title: "Create a new Task", subtitle: "", bgColor: Color("TaskBG"))
    }
}
