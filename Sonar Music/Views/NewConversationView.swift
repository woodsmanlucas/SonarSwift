//
//  NewConversationView.swift
//  Sonar Music
//
//  Created by Lucas Johnson on 2020-08-29.
//  Copyright © 2020 Sonar Music. All rights reserved.
//

import SwiftUI

struct NewConversationView: View {
    @Environment(\.presentationMode) var presentation
    var userId: String
    @ObservedObject var inbox: InboxViewModel
    @State var subject = ""
    @State var ConversationCreated = false
    
    func isConversationInformationValid() -> Bool {
        if self.subject == "" {
            return false
        }
        
        return true
    }
    
    var body: some View {
        VStack{
            Form{
            TextField("Subject", text: $subject)
            
            if (self.isConversationInformationValid()){
                Button(action: {self.inbox.createConversation(subject: self.subject, receiverId: self.userId)
                    self.ConversationCreated = true
                }){
                Text("Create a new Conversation")
            }
                }
            }
        }.sheet(isPresented: $ConversationCreated) { IndiviualConversationView(conversationId: self.inbox.conversationId!, otherUser: self.userId, inbox: self.inbox)}
    }
}
