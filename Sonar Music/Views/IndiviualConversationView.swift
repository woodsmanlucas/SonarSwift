//
//  IndiviualConversationView.swift
//  Sonar Music
//
//  Created by Lucas Johnson on 2020-09-19.
//  Copyright © 2020 Sonar Music. All rights reserved.
//

import SwiftUI
import Combine

struct IndiviualConversationView: View {
    let conversationId: String
    let otherUser: String
    @ObservedObject var inbox: InboxViewModel
    @State var newMessage = ""
    @State var messages: [Message] = []
    @State private var keyboardHeight: CGFloat = 0
    
    func isUserInformationValid() -> Bool {
        if (newMessage == ""){
            return false
        }
        return true
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack{
            if(self.messages.count > 0){
            ScrollView(.vertical){
                ForEach(self.messages, id: \._id){
                    message in
//                    Text(message.msg)
                                        MessageView(message: message, otherUser: self.otherUser )
                }
                }.padding(20)
            } else {
                Text("Loading ...")
                }
            Spacer()
            HStack{
                TextField("Message", text: self.$newMessage)
                    Button(action: {
                        self.inbox.sendMessage(otherUser: self.otherUser, newMessage: self.newMessage, conversationId: self.conversationId )
                        self.newMessage = ""
                        DispatchQueue.global(qos: .utility).async {
                        let result = self.inbox.getMessages(self.conversationId)
                                DispatchQueue.main.async {
                                    switch result {
                                        case let .success(data):
                                            self.messages = data
                                        case let .failure(data):
                                            print(data)
                                    }
                        }
                        }
                    }) {
                    Text("Send")
                }.disabled(!self.isUserInformationValid())
                }.frame(width: geometry.size.width - 40, height: 40).padding(20)
            }
        }.padding(.bottom, keyboardHeight)
        .onReceive(Publishers.keyboardHeight) { self.keyboardHeight = $0 }
        .onAppear{
            if(self.messages.isEmpty){
                DispatchQueue.global(qos: .utility).async {
                    let result = self.inbox.getMessages(self.conversationId)
                    DispatchQueue.main.async {
                        switch result {
                        case let .success(data):
                            self.messages = data
                            print("messages \(self.messages)")
                        case let .failure(data):
                            print(data)
                        }
                    }
                }
            }
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
                    Text(message.msg).foregroundColor(Color.white).fixedSize(horizontal: false, vertical: true)
                }.frame(minWidth: 250, idealWidth: 250, maxWidth: 250).padding(.trailing, 100)
//                }.frame(width: 250, height: height)
                }.padding(10)
            )
        }else{
            return AnyView(
                HStack{
                    ZStack{
                    RoundedRectangle(cornerRadius: 10).foregroundColor(Color.green)
                        Text(message.msg).foregroundColor(Color.white).fixedSize(horizontal: false, vertical: true)
                    }.frame(minWidth: 250, idealWidth: 250, maxWidth: 250).padding(.leading, 100)
//                    }.frame(width: 250, height: height)
            })
        }
    }
}

