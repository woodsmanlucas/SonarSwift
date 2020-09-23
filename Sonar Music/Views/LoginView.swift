//
//  Login.swift
//  Sonar Music
//
//  Created by Lucas Johnson on 2020-08-15.
//  Copyright © 2020 Sonar Music. All rights reserved.
//

import Combine
import SwiftUI

struct LoginView: View {
    @State var email: String = "woodsman.lucas@gmail.com"
    @State var password: String = "P@ssw0rd"
    @ObservedObject var jwt: JWT
    var messageUser: String = ""
    let Classifieds = ClassifiedsViewModel()
    @State var error: String?
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
     private func isUserInformationValid() -> Bool {
        if self.email.isEmpty {
                return false
            }
            
        if self.password.isEmpty {
                return false
            }
            
            return true
        }
        
        var body: some View {
            VStack{
            Form{
                TextField("Email", text: $email)
                SecureField("Password", text: $password)
                
                if self.isUserInformationValid() {
                    Button(action: {
                        DispatchQueue.global(qos: .utility).async {
                            let result = self.jwt.login(self.email, self.password)
                            DispatchQueue.main.async {
                                switch result {
                                case let .success(data):
                                    if(data != nil){
                                        self.error = data
                                    }else{
                                        self.presentationMode.wrappedValue.dismiss()

                                        }
                                case let .failure(data):
                                    print(data) 
                                }
                            }
                        }
                    }, label: {
                        Text("Log in")
                    })
                }
                if self.error != nil {
                    Text(self.error!).foregroundColor(Color.red)
                }
            }
        .navigationBarTitle("Login")

                
                if messageUser != "" {
                    
                NavigationLink(destination: NewConversationView(userId: messageUser, jwt: jwt), isActive: $jwt.pushed) { EmptyView() }
                    
                }
        }
    }
}
