//
//  RegisterView.swift
//  Sonar Music
//
//  Created by Lucas Johnson on 2020-08-15.
//  Copyright © 2020 Sonar Music. All rights reserved.
//

import SwiftUI

struct RegisterView: View {
    @State var email: String = ""
    @State var username: String = ""
    @State var firstName: String = ""
    @State var lastName: String = ""
    @State var password: String = ""
    @ObservedObject var viewModel: JWT
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
                        self.viewModel.register(email: self.email, username: self.username, firstName: self.firstName, lastName: self.lastName, password: self.password)
                    }, label: {
                        Text("Register")
                    })
                }
                if messageUser == "" {
                
                NavigationLink(destination: SplashPage(), isActive: $viewModel.pushed) { EmptyView() }
                    
                }
                else{
                    
                NavigationLink(destination: MessageUserView(userId: messageUser, jwt: viewModel), isActive: $viewModel.pushed) { EmptyView() }
                    
                }
            }
        .navigationBarTitle("Register")

        }
    }

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView(viewModel: JWT())
    }
}
