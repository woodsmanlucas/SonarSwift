//
//  MessagesView.swift
//  Sonar Music
//
//  Created by Lucas Johnson on 2020-09-08.
//  Copyright © 2020 Sonar Music. All rights reserved.
//

import SwiftUI

struct MessagesView: View {
    @ObservedObject var inbox: InboxViewModel
    
    var body: some View {
        ScrollView{
            if(self.inbox.conversations.count > 0){
            ForEach(self.inbox.conversations, id: \._id){
                conversation in
                ConversationView(conversation: conversation, inbox: self.inbox)
                }
            }
        }.onAppear{self.inbox.getConversations()}
            .navigationBarTitle("Inbox")
    }
}


struct ConversationView: View {
    var conversation: Conversation
    var inbox: InboxViewModel
    
    var body: some View {
        if(self.inbox.jwt.userId! == conversation.senderId){
            return NavigationLink(destination: IndiviualConversationView(conversationId: self.conversation._id, otherUser: self.conversation.receiverId, inbox: self.inbox)){
            HStack{
                Spacer()
                Text(conversation.subject).bold()
                Spacer(minLength: 20)
                Text("To: " + conversation.receiverId)
                }
                Spacer()
            }.foregroundColor(Color.black)
        }else{
            return NavigationLink(destination: IndiviualConversationView(conversationId: self.conversation._id, otherUser: self.conversation.senderId, inbox: self.inbox)){
            HStack{
                Spacer()
                Text(conversation.subject).bold()
                Spacer(minLength: 20)
                Text("From: " + conversation.senderId)
                }
                Spacer()
            }.foregroundColor(Color.black)
        }
    }
}
