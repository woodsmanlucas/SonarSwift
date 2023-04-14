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
    var pictureUrl: String?
    @ObservedObject var jwt: JWT
    
    init(_ classified: Classified, jwt: JWT) {
        self.classified = classified
        if(classified.pictures.count > 0){
            self.pictureUrl = classified.pictures[0]
        }
        self.jwt = jwt
        }
    
    var body: some View {
        guard let urlString = pictureUrl else {
            return AnyView(
                VStack{
                    Text(classified.title).bold()
                    Text(classified.description)
                    if jwt.token != nil {
                        //                    if false {
                        NavigationLink(destination: NewConversationView(userId: classified.user[0]!._id, inbox: InboxViewModel(jwt: jwt))){
                            Text("Message this user")
                        }
                        
                        NavigationLink(destination: ProfileView(user: UserViewModel(classified.user[0]!._id, jwt: jwt))){
                            Text("View this users profile")
                        }
                    }
                    else{
                        NavigationLink(destination: LoginView(jwt: jwt, messageUser: classified.user[0]!._id) ) {
                            Text("Login to Message this user")
                        }
                        NavigationLink(destination: RegisterView(jwt: jwt, messageUser: classified.user[0]!._id)){
                            Text("Register to Message this user")
                        }
                    }
                }.navigationBarTitle("Classified")            )
        }
        
        let url = URL(string: urlString)
        
        if(url != nil){
            
            return AnyView(
                VStack{
                    Text(classified.title).bold()
                    Text(classified.description)
                    AsyncImage(
                        url: url!
                    ).aspectRatio(contentMode: .fit)
                    if jwt.token != nil {
                        NavigationLink(destination: NewConversationView(userId: classified.user[0]!._id, inbox: InboxViewModel(jwt: jwt))){
                            Text("Message this user")
                        }
                        
                        NavigationLink(destination: ProfileView(user: UserViewModel(classified.user[0]!._id, jwt: jwt))){
                            Text("View this users profile")
                        }
                    }
                    else{
                        NavigationLink(destination: LoginView(jwt: jwt, messageUser: classified.user[0]!._id) ) {
                            Text("Login to Message or View this user")
                        }
                        NavigationLink(destination: RegisterView(jwt: jwt, messageUser: classified.user[0]!._id)){
                            Text("Register to Message or View this user")
                        }
                    }
                }.navigationBarTitle("Classified")
            )
        } else {
            return AnyView(

            VStack{
                Text(classified.title).bold()
                Text(classified.description)
                if jwt.token != nil {
                    NavigationLink(destination: NewConversationView(userId: classified.user[0]!._id, inbox: InboxViewModel(jwt: jwt))){
                        Text("Message this user")
                    }
                    
                    NavigationLink(destination: ProfileView(user: UserViewModel(classified.user[0]!._id, jwt: jwt))){
                        Text("View this users profile")
                    }
                }
                else{
                    NavigationLink(destination: LoginView(jwt: jwt, messageUser: classified.user[0]!._id) ) {
                        Text("Login to Message this user")
                    }
                    NavigationLink(destination: RegisterView(jwt: jwt, messageUser: classified.user[0]!._id)){
                        Text("Register to Message this user")
                    }
                }
            }.navigationBarTitle("Classified")
            )
        }
    }
}
