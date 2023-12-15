//
//  ButtonView.swift
//  ProjetoP3
//
//  Created by user243107 on 12/15/23.
//

import SwiftUI

struct ButtonView: View {
    let label: String
    let icon: String?
    var iconOnLeft: Bool?
    let action: () -> Void
    
    // Por default os structs ja tem initializers
    // Mas neste caso como temos valores opcionais
    // Temos que criar um init custom para os valores opcionais terem um valor default.
    init(
        label: String,
        icon: String? = nil,
        iconOnLeft: Bool? = true,
        action: @escaping () -> Void
    ) {
        self.label = label
        self.icon = icon
        self.iconOnLeft = iconOnLeft
        self.action = action
    }
    
    var body: some View {
        Button {
            action()
        } label: {
            HStack{
                if iconOnLeft == true, let icon {
                    Image(systemName: icon)
                }
                
                Text(label)
                
                if iconOnLeft == false, let icon {
                    Image(systemName: icon)
                }
            }
            .foregroundColor(.white)
            .frame(width: UIScreen.main.bounds.width - 32, height: 48)
        }
        .background(Color(.systemBlue))
        .cornerRadius(10)
        .padding(.top, 24)
    
        Divider()
    }
    
   
}

struct ButtonView_Previews: PreviewProvider {
    static var previews: some View {
        ButtonView(label: "My Button", icon: "star.fill", iconOnLeft: true) {}

    }
}
