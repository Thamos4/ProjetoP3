//
//  DropdownView.swift
//  ProjetoP3
//
//  Created by Thamos4 on 11/01/2024.
//

import SwiftUI

enum Anchor {
    case top
    case bottom
}

struct DropdownView: View {
    var hint: String
    var options: [String]
    var anchor: Anchor = .bottom
    var maxWidth: CGFloat = 120
    var cornerRadius: CGFloat = 15
    @Binding var selection: String
    @State private var showOptions: Bool = false
    @Environment(\.colorScheme) private var scheme
    @SceneStorage("drop_down_zindex") private var index = 1000.0
    @State private var zIndex: Double = 1000.0
    
    var body: some View {
        GeometryReader {
            let size = $0.size
            
            VStack(spacing: 0) {
                
                if showOptions && anchor == .top {
                    OptionsView()
                }
                
                HStack(spacing: 0) {
                    Text(selection.isEmpty ? hint : selection)
                        .foregroundStyle(selection.isEmpty ? .gray : .primary)
                        .lineLimit(1)
                        .font(.system(size: 12))
                    
                    Spacer(minLength: 0)
                    
                    Image(systemName: "chevron.down")
                        .font(.system(size: 12))
                        .foregroundStyle(.gray)
                        .rotationEffect(.init(degrees: showOptions ? -180 : 0))
                }
                .padding(.horizontal, 15)
                .frame(width: size.width, height: size.height)
                .background(Color("HomeBG"))
                .zIndex(10)
                .contentShape(Rectangle())
                .onTapGesture {
                    index += 1
                    zIndex = index
                    withAnimation(){
                        showOptions.toggle()
//                    }
                    
                }
                
                if showOptions && anchor == .bottom {
                    OptionsView()
                }
            }
            .clipped()
            .background(Color("HomeBG"))
            .frame(height: size.height, alignment: anchor == .top ? .bottom : .top)
        }
        .frame(width: maxWidth, height: 30)
        .zIndex(zIndex)
    }
    
    @ViewBuilder
    func OptionsView() -> some View {
        VStack(spacing: 10){
            ForEach(options, id: \.self) { option in
                HStack(spacing: 0) {
                    Text(option)
                        .lineLimit(1)
                        .font(.system(size: 12))
                    
                    Spacer(minLength: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/)
                    
                    Image(systemName: "checkmark")
                        .font(.caption)
                        .opacity(selection == option ? 1 : 0)
                }
                .foregroundStyle(selection == option ? Color.primary : Color.gray)
                .animation(.none, value: selection)
                .frame(height: 20)
                .contentShape(Rectangle())
                .onTapGesture {
                    withAnimation() {
                        selection = option
                        showOptions = false
//                    }
                }
            }
        }
        .padding(.horizontal, 15)
        .padding(.vertical, 5)
        .transition(.move(edge: anchor == .top ? .bottom : .top))
    }
}

struct DropdownView_Previews: PreviewProvider {
    static var previews: some View {
        let options =  ArticleRoom.allCases.map { $0.rawValue }
        
        DropdownView(hint: "Select", options: options, anchor: .bottom, selection: .constant("Room 1"))
    }
}
