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
    @State var error: String?
    @ObservedObject var jwt: JWT
    var messageUser: String? //User Id of user to be messaged

    
   
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
                        DispatchQueue.global(qos: .utility).async {
                            let result = self.jwt.register(email: self.email, username: self.username, firstName: self.firstName, lastName: self.lastName, password: self.password, self.messageUser)
                        DispatchQueue.main.async {
                            switch result {
                            case let .success(data):
                                if(data == nil){
                                    self.presentationMode.wrappedValue.dismiss()
                                    }
                                self.error = data
                            case let .failure(data):
                                print(data)
                            }
                        }
                        }
                    }, label: {
                        Text("Register")
                    })
                }
                
                if error != nil {
                    Text(error!).foregroundColor(Color.red)
                }
            }
        .navigationBarTitle("Register")

        }
    }
