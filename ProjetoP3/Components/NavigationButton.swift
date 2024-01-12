//
//  AddButtonView.swift
//  ProjetoP3
//
//  Created by user243107 on 1/10/24.
//

import SwiftUI

struct NavigationButton<Destination: View>: View {
    let label: String
    let icon: String
    let destination: Destination
    
    var body: some View {
        NavigationLink(destination: destination.navigationBarBackButtonHidden(true)){
            HStack {
                Image(systemName: icon)
                Text(label)
            }
            .foregroundColor(.white)
            .padding(.horizontal)
            .padding(.vertical,8)
            .background(Color("TaskBG"))
            .clipShape(Capsule())
            .font(.system(size: 14))
        }
    }
}

struct AddButtonView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationButton(label: "Add Task", icon: "plus",destination: Home())
    }
}
