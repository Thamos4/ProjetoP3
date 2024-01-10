//
//  AddButtonView.swift
//  ProjetoP3
//
//  Created by user243107 on 1/10/24.
//

import SwiftUI

struct AddButtonView: View {
    let label: String
    let action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            Image(systemName: "plus")
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

struct AddButtonView_Previews: PreviewProvider {
    static var previews: some View {
        AddButtonView(label: "Add Task"){}
    }
}
