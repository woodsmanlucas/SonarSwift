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
                if(self.inbox.messages.count > 0){
                ForEach(self.inbox.messages, id: \._id){
                    message in
                    MessageView(message: message, otherUser: self.otherUser)
                }
                }
                Spacer()
            }.padding(20)
            HStack{
                TextField("Message", text: $newMessage)
                    Button(action: {
                        self.inbox.sendMessage(otherUser: self.otherUser, newMessage: self.newMessage, conversationId: self.conversationId )
                        self.newMessage = ""
                        self.inbox.getMessages(self.conversationId)
                    }) {
                    Text("Send")
                }.disabled(!self.isUserInformationValid())
            }
        }.onAppear{
            self.inbox.getMessages(self.conversationId)
        }
        
    }
}

struct MessageView: View{
    var message: Message
    var otherUser: String
    
    var body: some View {
        if(message.senderId == otherUser){
            return AnyView(HStack{
                ZStack{
                    RoundedRectangle(cornerRadius: 10).foregroundColor(Color.purple)
                    Text(message.msg).foregroundColor(Color.white)

                }
                Spacer(minLength: 200)
                }
            )
        }else{
            return AnyView(
                HStack{
                Spacer(minLength: 200)
                    ZStack{
                    RoundedRectangle(cornerRadius: 10).foregroundColor(Color.green)
                        Text(message.msg).foregroundColor(Color.white)

                    }
            })
        }
    }
}

