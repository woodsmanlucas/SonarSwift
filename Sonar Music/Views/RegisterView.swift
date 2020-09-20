//
//  RegisterView.swift
//  Sonar Music
//
//  Created by Lucas Johnson on 2020-08-15.
//  Copyright © 2020 Sonar Music. All rights reserved.
//

import SwiftUI

struct RegisterView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State var email: String = ""
    @State var username: String = ""
    @State var firstName: String = ""
    @State var lastName: String = ""
    @State var password: String = ""
    @ObservedObject var jwt: JWT
    var messageUser: String = "" //User Id of user to be messaged

    
   
     private func isUserInformationValid() -> Bool {
            if email.isEmpty {
                return false
            }
            
            if password.isEmpty {
                return false
            }
        
        if username.isEmpty {
            return false
        }
            
            return true
        }
        
        var body: some View {
            Form{
                TextField("Email", text: $email)
                TextField("UserName", text: $username)
                TextField("firstName", text: $firstName)
                TextField("lastName", text: $lastName)
                SecureField("Password", text: $password)
                
                if self.isUserInformationValid() {
                    Button(action: {
                        self.jwt.register(email: self.email, username: self.username, firstName: self.firstName, lastName: self.lastName, password: self.password)
                        self.presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Text("Register")
                    })
                }
                if messageUser == "" {
                
                NavigationLink(destination: SplashPage(), isActive: $jwt.pushed) { EmptyView() }
                    
                }
                else{
                    
                NavigationLink(destination: NewConversationView(userId: messageUser, jwt: jwt), isActive: $jwt.pushed) { EmptyView() }
                    
                }
            }
        .navigationBarTitle("Register")

        }
    }
