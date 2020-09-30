//
//  InboxViewModel.swift
//  Sonar Music
//
//  Created by Lucas Johnson on 2020-08-29.
//  Copyright © 2020 Sonar Music. All rights reserved.
//

import SwiftUI

struct InboxJsonResponse: Codable {
    var success: Bool
    var convo: [Conversation]
}

struct Conversation: Codable {
    var _id: String
    var subject: String
    var receiverId: String
    var senderId: String
    var user: [UserUsernameOnly]
}

struct CreateConversationJsonResponse: Codable{
    var success: Bool
    var convo: ConversationWithoutUser
}
struct ConversationWithoutUser: Codable {
    var _id: String
}

struct UserUsernameOnly: Codable {
    var username: String
}

struct MessagesJsonResponse: Codable {
    var success: Bool
    var messages: [Message]
}

struct Message: Codable {
    var _id: String
    var msg: String
    var receiverId: String
    var senderId: String
}

class InboxViewModel: ObservableObject {
    @ObservedObject var jwt: JWT
    @Published private(set) var conversations: [Conversation] = []
    @Published private(set) var messages: [Message] = []
    @Published private(set) var conversationId: String?
    
    init(jwt: JWT){
        self.jwt = jwt
    }
    
    func getConversations() {
                // Prepare URL
               let url = URL(string: "https://www.sonarmusic.social/api/inbox/")
               guard let requestUrl = url else { fatalError() }
           
               // Prepare URL Request Object
                var request = URLRequest(url: requestUrl)
        
                // Set JWT
                request.setValue(self.jwt.token!, forHTTPHeaderField: "Authorization")

        
           
               // Perform HTTP Request
               let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
               
                   // Check for Error
                   if let error = error {
                       print("Error took place \(error)")
                       return
                   }
        
                   // Convert HTTP Response Data to a String
                   if let data = data, let dataString = String(data: data, encoding: .utf8) {
                       print("Response data string:\n \(dataString)")
                       print(data)
                   do{
                              let inboxData = try JSONDecoder().decode(InboxJsonResponse.self, from: data)
                       print(inboxData.convo)
                       if inboxData.success{
                           DispatchQueue.main.async {
                               self.conversations = inboxData.convo
                               print("conversations \(self.conversations)")

                           }
                       }
                   } catch let error as NSError {
                       print("Failed to load: \(error.localizedDescription)")
                   }

               }

           }
           task.resume()
    }
    
    func createConversation(subject: String, receiverId: String) {
        let semaphore = DispatchSemaphore (value: 0)

        let parameters = "{\n    \"receiverId\": \"\(receiverId)\",\n    \"subject\": \"\(subject)\"\n}"
        let postData = parameters.data(using: .utf8)

        var request = URLRequest(url: URL(string: "https://www.sonarmusic.social/api/inbox/")!,timeoutInterval: Double.infinity)
        request.addValue(self.jwt.token!, forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        request.httpMethod = "POST"
        request.httpBody = postData

       URLSession.shared.dataTask(with: request) { (data, response, error) in
                        // Check for Error
                           if let error = error {
                               print("Error took place \(error)")
                               return
                           }
                
            if let data = data {
              print(String(data: data, encoding: .utf8)!)
                do{
              let inboxData = try JSONDecoder().decode(CreateConversationJsonResponse.self, from: data)
                if inboxData.success{
                    DispatchQueue.main.async {
                        self.conversationId = inboxData.convo._id
                    }
                        }
                    } catch let error as NSError {
                        print("Failed to load: \(error.localizedDescription)")
                    }
            }
            semaphore.signal()
        }.resume()
        semaphore.wait()
    }
    
    func getMessages(_ conversationId: String) -> Result<[Message], NetworkError> {
        
            var result: Result<[Message], NetworkError> = .failure(.unknown)

        
            let semaphore = DispatchSemaphore(value: 0)

        
                        // Prepare URL
               let url = URL(string: "https://www.sonarmusic.social/api/inbox/conversation/" + conversationId)
               guard let requestUrl = url else { fatalError() }
           
               // Prepare URL Request Object
                var request = URLRequest(url: requestUrl)
        
                // Set JWT
                request.setValue(self.jwt.token!, forHTTPHeaderField: "Authorization")

        
           
               // Perform HTTP Request
               let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
               
                   // Check for Error
                   if let error = error {
                       print("Error took place \(error)")
                       return
                   }
        
                   // Convert HTTP Response Data to a String
                   if let data = data, let dataString = String(data: data, encoding: .utf8) {
                       print("Response data string:\n \(dataString)")
                   do{
                    let messagesData = try JSONDecoder().decode(MessagesJsonResponse.self, from: data)
                       if messagesData.success{
                           DispatchQueue.main.async {
                               self.messages = messagesData.messages
                                result = .success(messagesData.messages)
                                semaphore.signal()
                           }
                       }
                   } catch let error as NSError {
                       print("Failed to load: \(error.localizedDescription)")
                   }

               }
           }
           task.resume()
        
        _ = semaphore.wait(wallTimeout: .distantFuture)
        
        return result
    }
    
    func sendMessage(otherUser: String, newMessage: String, conversationId: String){
                        // Prepare URL
               let url = URL(string: "https://www.sonarmusic.social/api/messages/create/" + conversationId)
               guard let requestUrl = url else { fatalError() }
           
               // Prepare URL Request Object
                var request = URLRequest(url: requestUrl)
                request.httpMethod = "POST"

                // HTTP Request Parameters which will be sent in HTTP Request Body
                let postString = "msg=\(newMessage)&receiverId=\(otherUser)";
        
                // Set HTTP Request Body
                request.httpBody = postString.data(using: String.Encoding.utf8);
        
                // Set JWT
                request.setValue(self.jwt.token!, forHTTPHeaderField: "Authorization")

        
           
               // Perform HTTP Request
               let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
               
                   // Check for Error
                   if let error = error {
                       print("Error took place \(error)")
                       return
                   }
        
                   // Convert HTTP Response Data to a String
                   if let data = data, let dataString = String(data: data, encoding: .utf8) {
                       print("Response data string:\n \(dataString)")
                       print(data)
                   do{
                    let messagesData = try JSONDecoder().decode(MessagesJsonResponse.self, from: data)
                       if messagesData.success{
                           DispatchQueue.main.async {
                               self.messages = messagesData.messages
                               print("messages \(self.conversations)")

                           }
                       }
                   } catch let error as NSError {
                       print("Failed to load: \(error.localizedDescription)")
                   }

               }

           }
           task.resume()
    }
}
