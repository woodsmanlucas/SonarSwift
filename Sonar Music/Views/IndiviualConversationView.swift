//
//  IndiviualConversationView.swift
//  Sonar Music
//
//  Created by Lucas Johnson on 2020-09-19.
//  Copyright © 2020 Sonar Music. All rights reserved.
//

extension UIScreen{
   static let screenWidth = UIScreen.main.bounds.size.width
   static let screenHeight = UIScreen.main.bounds.size.height
   static let screenSize = UIScreen.main.bounds.size
}

import SwiftUI

struct IndiviualConversationView: View {
    let conversationId: String
    let otherUser: String
    @ObservedObject var inbox: InboxViewModel
    @ObservedObject private var kGuardian = KeyboardGuardian(textFieldCount: 1)
    @State var newMessage = ""
    @State private var keyboardHeight: CGFloat = 0
    
    func isUserInformationValid() -> Bool {
        if (newMessage == ""){
            return false
        }
        return true
    }
    
    func getHeight(_ count: Int) -> CGFloat {
        if (count > 30)
        {
            print(CGFloat(count/2))
            return CGFloat(count/2)
        }else{
            return CGFloat(15)
            }
    }
    
    var body: some View {
        VStack{
            ScrollView(.vertical){
                if(self.inbox.messages.count > 0){
                ForEach(self.inbox.messages, id: \._id){
                    message in
                    MessageView(message: message, otherUser: self.otherUser, height: self.getHeight(message.msg.count) )
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
            }.frame(width: UIScreen.screenWidth, height: 40)
        }
            .onAppear{
            self.inbox.getMessages(self.conversationId)
        }.offset(y: kGuardian.slide).animation(.easeInOut(duration: 1.0))
        
        
    }
}

struct MessageView: View{
    var message: Message
    var otherUser: String
    var height: CGFloat

    var body: some View {
        if(message.senderId == otherUser){
            return AnyView(HStack{
                ZStack{
                    RoundedRectangle(cornerRadius: 10).foregroundColor(Color.purple)
                    Text(message.msg).foregroundColor(Color.white)
                }.frame(width: 250, height: height)
                Spacer(minLength: 100)
                }.padding(10)
            )
        }else{
            return AnyView(
                HStack{
                Spacer(minLength: 100)
                    ZStack{
                    RoundedRectangle(cornerRadius: 10).foregroundColor(Color.green)
                        Text(message.msg).foregroundColor(Color.white)
                    }.frame(width: 250, height: height)
            })
        }
    }
}

