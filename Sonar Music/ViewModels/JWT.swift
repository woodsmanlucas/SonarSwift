//
//  LoginViewModel.swift
//  Sonar Music
//
//  Created by Lucas Johnson on 2020-08-17.
//  Copyright © 2020 Sonar Music. All rights reserved.
//

import SwiftUI

enum NetworkError: Error {
    case url
    case server
    case unknown
}

class JWT: ObservableObject {
    @Published private(set) var token: String?
    @Published private(set) var userId: String?
    @Published var pushed = false
    @Published var error: String?
    @Published var messageUser: String?
    
    func logout(){
        token = nil
        userId = nil
    }
    
    func login(_ email: String, _ password: String, _ messageUserId: String?) -> Result<String?, NetworkError>{
        DispatchQueue.main.async {
        self.messageUser = messageUserId
        }
        
        var result: Result<String?, NetworkError> = .failure(.unknown)
        
        let semaphore = DispatchSemaphore(value: 0)
        
        // Prepare URL
        let url = URL(string: "https://www.sonarmusic.social/api/auth/login")
        guard let requestUrl = url else { return .failure(.url) }
        
        // Prepare URL Request Object
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "POST"
     
        // HTTP Request Parameters which will be sent in HTTP Request Body
        let postString = "email=\(email)&password=\(password)";
        
        // Set HTTP Request Body
        request.httpBody = postString.data(using: String.Encoding.utf8);
        
        // Perform HTTP Request
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            // Check for Error
            if let error = error {
                print("Error took place \(error)")
            }
            

            // Convert HTTP Response Data to a String
            if let data = data, let dataString = String(data: data, encoding: .utf8) {
                print("Response data string:\n \(dataString)")

                do{
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        if let token = json["token"] as? String{
                            print(token)
                            DispatchQueue.main.async {
                                self.token = token
                                if(messageUserId != ""){
                                    self.pushed = true
                                }
                            }
                        }
                        if let user = json["user"] as? String{
                             print(user)
                             DispatchQueue.main.async {
                                 self.userId = user
                             }
                         }
                        if let msg = json["msg"] as? String{
                            result = .success(msg)
                        }else{
                            result = .success(nil)
                        }
                    }
                } catch let error as NSError {
                    print("Failed to load: \(error.localizedDescription)")
                    result = .success(dataString)
                }
            }else{
                result = .failure(.server)
            }
            semaphore.signal()

        }.resume()
        
        _ = semaphore.wait(wallTimeout: .distantFuture)

        
        print(result)
        return result
    }
    
    func register(email: String, username: String, firstName: String, lastName: String, password: String, _ messageUserId: String?) -> Result<String?, NetworkError>{
        
        DispatchQueue.main.async {
        self.messageUser = messageUserId
        }
        
        var result: Result<String?, NetworkError> = .failure(.unknown)
        
        let semaphore = DispatchSemaphore(value: 0)
        
        
        // Prepare URL
        let array: [String] = []
        
           print("\(array)")
           let url = URL(string: "https://www.sonarmusic.social/api/auth/register")
           guard let requestUrl = url else { fatalError() }
           
           // Prepare URL Request Object
           var request = URLRequest(url: requestUrl)
           request.httpMethod = "POST"
        
           // HTTP Request Parameters which will be sent in HTTP Request Body
           let postString = "email=\(email)&username=\(username)&firstName=\(firstName)&lastName=\(lastName)&password=\(password)&userType='user'";
           
           // Set HTTP Request Body
           request.httpBody = postString.data(using: String.Encoding.utf8);
           
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
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        if let token = json["token"] as? String{
                            print(token)
                            DispatchQueue.main.async {
                                self.token = token
                                self.pushed = true
                            }
                        }
                        if let user = json["user"] as? String{
                             print(user)
                             DispatchQueue.main.async {
                                 self.userId = user
                             }
                         }
                        if let msg = json["msg"] as? String{
                            result = .success(msg)
                        }else{
                            result = .success(nil)
                        }
                    }
                } catch let error as NSError {
                    print("Failed to load: \(error.localizedDescription)")
                    result = .success(dataString)
                }
                
            }
            semaphore.signal()

           }
           task.resume()
        
            _ = semaphore.wait(wallTimeout: .distantFuture)
        
        return result
    }
}
