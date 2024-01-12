//
//  DropdownView.swift
//  ProjetoP3
//
//  Created by Catarina Vasconcelos on 11/01/2024.
//

import SwiftUI

enum Anchor {
    case top
    case bottom
}

struct DropdownView: View {
    var hint: String
    var options: [any AnyDropdownOption]
    var anchor: Anchor = .bottom
    var maxWidth: CGFloat = 120
    var cornerRadius: CGFloat = 15
    @Binding var selection: String
    @State var selectedName: String = ""
    @State private var showOptions: Bool = false
    @Environment(\.colorScheme) private var scheme
    @SceneStorage("drop_down_zindex") private var index = 1000.0
    @State private var zIndex: Double = 1000.0
    
    init(hint: String, options: [String], anchor: Anchor = .bottom, maxWidth: CGFloat = 120, cornerRadius: CGFloat = 15, selection: Binding<String>){
        self.hint = hint
        self.options = options.map { StringDropdownOption(value: $0) }
        self.anchor = anchor
        self.maxWidth = maxWidth
        self.cornerRadius = cornerRadius
        self._selection = selection
    }
    
    init(hint: String, options: [Track], anchor: Anchor = .bottom, maxWidth: CGFloat = 120, cornerRadius: CGFloat = 15, selection: Binding<String>){
        self.hint = hint
        self.options = options.map { TrackDropdownOption(track: $0) }
        self.anchor = anchor
        self.maxWidth = maxWidth
        self.cornerRadius = cornerRadius
        self._selection = selection
    }
    
    var body: some View {
        GeometryReader {
            let size = $0.size
            
            VStack(spacing: 0) {
                
                if showOptions && anchor == .top {
                    OptionsView()
                }
                
                HStack(spacing: 0) {
                    Text(selectedName.isEmpty ? hint : selectedName)
                        .foregroundStyle(selectedName.isEmpty ? .gray : .primary)
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
                .onTapGesture {
                    index += 1
                    zIndex = index
                    withAnimation(){
                        showOptions.toggle()
                    }
                    
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
            ForEach(options, id: \.id) { option in
                HStack(spacing: 0) {
                    Text(option.name)
                        .lineLimit(1)
                        .font(.system(size: 12))
                    
                    Spacer(minLength: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/)
                    
                    Image(systemName: "checkmark")
                        .font(.caption)
                        .opacity(selectedName == option.name ? 1 : 0)
                }
                .foregroundStyle(selectedName == option.name ? Color.primary : Color.gray)
                .animation(.none, value: selectedName)
                .frame(height: 20)
                .onTapGesture {
                    withAnimation() {
                        selection = option.savedValue
                        selectedName = option.name
                        showOptions = false
                        print("Selection (id): ",selection)
                        print("SelectedName (displayed)",selectedName)
                    }
                }
            }
        }
        .padding(.horizontal, 15)
        .padding(.vertical, 5)
        .transition(.move(edge: anchor == .top ? .bottom : .top))
    }
}

protocol AnyDropdownOption: Identifiable, Hashable{
    var name: String {get}
    var savedValue: String{get}
    var id: String {get}
}

struct StringDropdownOption: AnyDropdownOption{
    let id = NSUUID().uuidString
    let name: String
    init(value: String){
        self.name = value
    }
    var savedValue: String{
        return name
    }
}

struct TrackDropdownOption: AnyDropdownOption{
    let id = NSUUID().uuidString
    let trackId: String
    let name: String
    
    init(track: Track){
        self.trackId = track.id
        self.name = track.name
    }
    var savedValue: String{
        return trackId
    }
}

struct DropdownView_Previews: PreviewProvider {
    static var previews: some View {
        let options =  ArticleRoom.allCases.map { $0.rawValue }
        @State var selectedTrack: String = ""
        let options2 = [Track(id: "id1", name: "Track 1", description: "desc1", conferenceId: "conf1"),
        Track(id: "id2", name: "Track 2", description: "desc2", conferenceId: "conf2")]
        
        VStack{
            DropdownView(hint: "Select", options: options2, anchor: .bottom, selection: $selectedTrack )
            
            DropdownView(hint: "Select", options: options, anchor: .bottom, selection: .constant("Room 1"))
        }
    }
}
