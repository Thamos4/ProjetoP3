//
//  InputView.swift
//  ProjetoP3
//
//  Created by user243107 on 12/15/23.
//

import SwiftUI

struct InputView: View {
   
  //  let title: String
    let imageName: String
    let placeholder: String
    @Binding var text: String
   var isSecureField = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack{
                Image(systemName: imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                    .foregroundColor(Color(.darkGray))
               
                
                if isSecureField {
                    SecureField(placeholder, text: $text)
                        .font(.system(size: 14))
                } else {
                    TextField(placeholder, text: $text)
                        .font(.system(size: 14))
                }
            }
            Divider()
        }
    }
}

struct InputView_Previews: PreviewProvider {
    static var previews: some View {
        InputView(imageName: "envelope",
                  placeholder: "Email",
                  text: .constant(""))
    }
}
