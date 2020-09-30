//
//  SplashPage.swift
//  Sonar Music
//
//  Created by Lucas Johnson on 2020-08-15.
//  Copyright © 2020 Sonar Music. All rights reserved.
//

import SwiftUI

struct SplashPage: View {
    @ObservedObject var jwt: JWT
    @ObservedObject var classifieds: ClassifiedsViewModel
    @State var loaded: Bool = true
    
    init() {
        let jwt = JWT()
        self.classifieds = ClassifiedsViewModel(jwt: jwt)
        self.jwt = jwt
    }

    var body: some View {
        VStack{
//            if true {
            if (self.jwt.messageUser != nil && self.jwt.token != nil  && self.jwt.userId != nil){
                VStack{
                    RectangleView("View all Messages"){MessagesView(inbox: InboxViewModel(jwt: self.jwt))}
                    RectangleView("Classifieds"){ClassifiedsView(viewModel: self.classifieds, jwt: self.jwt)}
                    RectangleView("My Profile"){ProfileView(user: UserViewModel(self.jwt.userId!, jwt: self.jwt))}
                    RectangleView("Create a classified"){CreateClassifiedView(classifieds: self.classifieds, jwt: self.jwt)}
                    RectangleView("My Classifieds"){MyClassifiedsView(viewModel: self.classifieds)}
                    ZStack{
                        RoundedRectangle(cornerRadius: 10.0).foregroundColor(Color.green)
                        Text("Log out").foregroundColor(Color.white)
                    }.frame(width: 200, height: 40)
                    .onTapGesture {
                        self.jwt.logout()
                    }
                }.sheet(isPresented: self.$loaded){
                    NewConversationView(userId: self.jwt.messageUser!, inbox: InboxViewModel(jwt: self.jwt))
                }
            }else if (self.jwt.token != nil  && self.jwt.userId != nil){
                    VStack{
                        RectangleView("View all Messages"){MessagesView(inbox: InboxViewModel(jwt: self.jwt))}
                        RectangleView("Classifieds"){ClassifiedsView(viewModel: self.classifieds, jwt: self.jwt)}
                        RectangleView("My Profile"){ProfileView(user: UserViewModel(self.jwt.userId!, jwt: self.jwt))}
                        RectangleView("Create a classified"){CreateClassifiedView(classifieds: self.classifieds, jwt: self.jwt)}
                        RectangleView("My Classifieds"){MyClassifiedsView(viewModel: self.classifieds)}
                        ZStack{
                            RoundedRectangle(cornerRadius: 10.0).foregroundColor(Color.green)
                            Text("Log out").foregroundColor(Color.white)
                        }.frame(width: 200, height: 40)
                        .onTapGesture {
                            self.jwt.logout()
                        }
                    }
            }else {
            RectangleView("Login"){LoginView(jwt: self.jwt)}
            RectangleView("Register"){RegisterView(jwt: self.jwt)}
                NavigationLink(destination: ClassifiedsView(viewModel: classifieds, jwt: self.jwt)){
            Text("View Classifieds without logging in")
            }
            }
        }.padding(40)
        .navigationBarTitle("Sonar Music")
        }
    }

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        SplashPage()
    }
}
