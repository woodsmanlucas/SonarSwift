//
//  IndiviualConversationView.swift
//  Sonar Music
//
//  Created by Lucas Johnson on 2020-09-19.
//  Copyright © 2020 Sonar Music. All rights reserved.
//

import SwiftUI

struct IndiviualConversationView: View {
    let conversationId: String
    let otherUser: String
    @ObservedObject var inbox: InboxViewModel
    @State var newMessage = ""
    
    func isUserInformationValid() -> Bool {
        if (newMessage == ""){
            return false
        }
        return true
    }
    
    var body: some View {
        VStack{
            ScrollView{
                Text("Hello, World!")
                Spacer()
            }
            HStack{
                TextField("Message", text: $newMessage)
                    Button(action: {
                        self.inbox.sendMessage(otherUser: self.otherUser, newMessage: self.newMessage, conversationId: self.conversationId )
                        self.newMessage = ""
                    }) {
                    Text("Send")
                }.disabled(!self.isUserInformationValid())
            }
        }.onAppear{
            self.inbox.getMessages(self.conversationId)
        }
        
    }
}
