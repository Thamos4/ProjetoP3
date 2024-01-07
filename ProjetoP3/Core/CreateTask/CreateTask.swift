//
//  LoginView.swift
//  ProjetoP3
//
//  Created by user243107 on 12/14/23.
//

import SwiftUI

struct CreateTask: View {
    @State private var name = ""
    @State private var date = ""

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
                    VStack(alignment: .leading) {
                        Text("Create a new Task")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(Color.white)
                            .padding(.trailing)
                        Spacer()
                    }
                    .padding(.leading, 25)
                    .padding(.top, 30)
                    Spacer()
                }
                VStack(spacing: 40){
                    InputView(imageName: "pencil", placeholder: "Task Name", text: $name)
                        .autocapitalization(.none)
                    InputView(imageName: "calendar", placeholder: "Date", text: $name)
                        .autocapitalization(.none)
                }
                .padding(.horizontal)
                .padding(.bottom, 120)
                
                Button{
                    print("Create Task")
                }label: {
                    Text("Create Task")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(width: 340, height: 50)
                        .background(Color("TaskBG"))
                        .clipShape(Capsule())
                        .padding()
                }
                .padding(.top, 150)
            }
        }.toolbar(.hidden, for: .tabBar)
    }
}


struct CreateTask_Previews: PreviewProvider {
    static var previews: some View {
        CreateTask()
    }
}
