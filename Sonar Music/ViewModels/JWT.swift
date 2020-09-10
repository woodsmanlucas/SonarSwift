//
//  LoginViewModel.swift
//  Sonar Music
//
//  Created by Lucas Johnson on 2020-08-17.
//  Copyright © 2020 Sonar Music. All rights reserved.
//

import SwiftUI

class JWT: ObservableObject {
    @Published private(set) var token: String?
    @Published private(set) var userId: String?
    @Published var pushed = false
    
    func login(_ email: String, _ password: String) {
        // Prepare URL
        let url = URL(string: "https://www.sonarmusic.social/api/auth/login")
        guard let requestUrl = url else { fatalError() }
        
        // Prepare URL Request Object
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "POST"
     
        // HTTP Request Parameters which will be sent in HTTP Request Body
        let postString = "email=\(email)&password=\(password)";
        
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
                    }
                } catch let error as NSError {
                    print("Failed to load: \(error.localizedDescription)")
                }

            }

        }
        task.resume()
        }
    
    func register(email: String, username: String, firstName: String, lastName: String, password: String){
        // Prepare URL
            let userType = "user"
        let array: [String] = []
        
           print("\(array)")
           let url = URL(string: "http://www.sonarmusic.social/api/auth/register")
           guard let requestUrl = url else { fatalError() }
           
           // Prepare URL Request Object
           var request = URLRequest(url: requestUrl)
           request.httpMethod = "POST"
        
           // HTTP Request Parameters which will be sent in HTTP Request Body
           let postString = "email=\(email)&username=\(username)&firstName=\(firstName)&lastName=\(lastName)&password=\(password)&gigsById=\(array)&badgesById=[]&pendingFirends=[]&friends=[]&following=[]&followers=[]&userType=\(userType)";
           
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

            }
           }
           task.resume()    }
}
