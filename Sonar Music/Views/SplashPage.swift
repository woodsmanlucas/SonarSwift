//
//  SplashPage.swift
//  Sonar Music
//
//  Created by Lucas Johnson on 2020-08-15.
//  Copyright © 2020 Sonar Music. All rights reserved.
//

import SwiftUI

struct SplashPage: View {
    @ObservedObject var LoginAndRegister = JWT()
    let Classifieds = ClassifiedsViewModel()

    var body: some View {
        VStack{
//            if true {
            if self.LoginAndRegister.token != nil  && self.LoginAndRegister.userId != nil{
                    VStack{
                    RectangleView("View all Messages"){MessagesView()}
                        RectangleView("Classifieds List"){ClassifiedsView(viewModel: self.Classifieds)}
                        RectangleView("Classifieds Map"){ClassifiedMapView(classifieds: self.Classifieds.classifieds)}
                        RectangleView("My Profile"){ProfileView(profile: ProfileViewModel(self.LoginAndRegister.userId!, jwt: self.LoginAndRegister))}

                    }
            }
            else{
            RectangleView("Login"){LoginView(viewModel: self.LoginAndRegister)}
            RectangleView("Register"){RegisterView(viewModel: self.LoginAndRegister)}
            NavigationLink(destination: ClassifiedsView(viewModel: Classifieds)){
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
