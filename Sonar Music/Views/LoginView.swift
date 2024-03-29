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
    @State var email: String = ""
    @State var password: String = ""
    @ObservedObject var jwt: JWT
    var messageUser: String?
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
                TextField("Email", text: $email).keyboardType(.emailAddress)
                SecureField("Password", text: $password)
                
                if self.isUserInformationValid() {
                    Button(action: {
                        DispatchQueue.global(qos: .utility).async {
                            let result = self.jwt.login(self.email, self.password, self.messageUser)
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
    }
}
}
