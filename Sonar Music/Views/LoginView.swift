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
    @ObservedObject var viewModel: JWT
    var messageUser: String = ""
    let Classifieds = ClassifiedsViewModel()
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
                        self.viewModel.login(self.email, self.password)
                        self.presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Text("Log in")
                    })
                }
            }
        .navigationBarTitle("Login")
                if messageUser == "" {
                
                NavigationLink(destination: SplashPage(), isActive: $viewModel.pushed) { EmptyView() }
                    
                }
                else{
                    
                NavigationLink(destination: MessageUserView(userId: messageUser, jwt: viewModel), isActive: $viewModel.pushed) { EmptyView() }
                    
                }
        }
    }
}


struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(viewModel: JWT())
    }
}
