//
//  SingleClassifiedView.swift
//  Sonar Music
//
//  Created by Lucas Johnson on 2020-08-25.
//  Copyright © 2020 Sonar Music. All rights reserved.
//

import SwiftUI

struct SingleClassifiedView: View {
    var classified: Classified
    var pictureUrl: URL?
    @ObservedObject var jwt: JWT
    
    init(_ classified: Classified, jwt: JWT) {
        self.classified = classified
        if(classified.pictures.count > 0){
            self.pictureUrl = URL(string: classified.pictures[0])!
        }
        self.jwt = jwt
        }
    
    var body: some View {
        guard let url = pictureUrl else {
                   return AnyView(
                   VStack{
                       Text(classified.title).bold()
                        Text(classified.description)
                    if jwt.token != nil {
//                    if false {
                        NavigationLink(destination: MessageUserView(userId: classified.user[0]!._id, jwt: jwt)){
                        Text("Message this user")
                        }
                    }
                    else{
                        NavigationLink(destination: LoginView(viewModel: jwt, messageUser: classified.user[0]!._id) ) {
                            Text("Login to Message this user")
                            }
                        NavigationLink(destination: RegisterView(viewModel: jwt, messageUser: classified.user[0]!._id)){
                          Text("Register to Message this user")
                        }
                    }
                       }.navigationBarTitle("Classified")            )
               }
               
               return AnyView(
                   VStack{
                       Text(classified.title).bold()
                       Text(classified.description)
                           AsyncImage(
                               url: url,
                               placeholder: Text("Loading ...")
                           ).aspectRatio(contentMode: .fit)
                   }.navigationBarTitle("Classified")
               )
    }
}
