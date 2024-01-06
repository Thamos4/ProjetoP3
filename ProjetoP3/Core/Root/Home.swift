//
//  LoginView.swift
//  ProjetoP3
//
//  Created by user243107 on 12/14/23.
//

import SwiftUI

struct Home: View {
    @State private var email = ""
    @State private var password = ""
    @EnvironmentObject var viewModel: AuthViewModel
    @State private var isError = false
    @State private var image: UIImage? = nil
    
    var body: some View {
        if let user = viewModel.currentUser {
            NavigationStack {
                VStack{
                    //hamburger e profile photo
                    ScrollView {
                        VStack(alignment: .leading){
                            HStack{
                                Image(systemName: "line.3.horizontal")
                                    .imageScale(.large)
                                    .frame(width: 40, height: 40)
                                
                                Spacer()
                                if let image {
                                    Image(uiImage: image)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 40, height: 40)
                                        .cornerRadius(10)
                                        .clipShape(Circle())
                                } else {
                                    Image(systemName: "person")
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 40, height: 40)
                                        .clipShape(Circle())
                                        .padding([.top, .trailing], 14)
                                }
                                
                            }
                            Text("Manage\nyour tasks")
                                .font(.system(size: 50))
                        }
                        //cards (pode ser outro background depois)
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 20) {
                                ForEach(0..<5) {
                                    Text("Item \($0)")
                                        .foregroundStyle(.white)
                                        .font(.largeTitle)
                                        .frame(width: 175, height: 225)
                                        .background(
                                            LinearGradient(gradient: Gradient(colors: [.indigo, .purple]), startPoint: .top, endPoint: .bottom))
                                        .cornerRadius(10)
                                }
                            }
                        }
                        Text("Progress")
                            .font(.system(size: 30))
                            .padding(.top, 30)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        VStack(alignment: .leading, spacing: 15){
                            HStack {
                                Text("15/24/2024")
                                    .font(.caption)
                                    .padding(.horizontal)
                                    .padding(.vertical, 8)
                                    .background(.black.opacity(0.1))
                                    .clipShape(Capsule())
                                
                                Spacer()
                                
                            }
                            Text("Random conference 007")
                                .font(.title3)
                            
                            HStack{
                                Image(systemName: "person")
                            }
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color("CardBG"))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .padding()
                        
                        VStack(alignment: .leading, spacing: 15){
                            HStack {
                                Text("15/24/2024")
                                    .font(.caption)
                                    .padding(.horizontal)
                                    .padding(.vertical, 8)
                                    .background(.black.opacity(0.1))
                                    .clipShape(Capsule())
                                
                                Spacer()
                                
                            }
                            Text("Random conference 007")
                                .font(.title3)
                            
                            HStack{
                                Image(systemName: "person")
                            }
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color("CardBG"))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .padding()
                        
                    }
                    .padding(.horizontal)
                    
                }
            }.task {
                 let image = try? await StoreManager.shared.getImage(userId: user.id, path: user.profileImagePath)
                 
                 self.image = image
            }
        }
    }
}


struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
