//
//  ProfileViewModel.swift
//  Sonar Music
//
//  Created by Lucas Johnson on 2020-09-10.
//  Copyright © 2020 Sonar Music. All rights reserved.
//

import SwiftUI

struct ProfileJsonResponse: Codable {
    var success: Bool
    var user: [Profile]
}

struct Profile: Codable {
    var _id: String
    var experience: [Int]
    var instrumentsPlayed: [String]
    var username: String
    var firstName: String
    var lastName: String
    var links: [String]
    var genre: [String]
    var profilePicUrl: String?
}

class ProfileViewModel: ObservableObject {
    @ObservedObject var jwt: JWT
    @Published private(set) var profile: [Profile] = []
    @Published private(set) var loaded = false
    var userId: String
    
    init(_ user_id: String, jwt: JWT){
        self.userId = user_id
        self.jwt = jwt
    }
    
    func GetProfile() {
                // prepare URL
                let url = URL(string: ("https://www.sonarmusic.social/api/users/" + userId))
               guard let requestUrl = url else { fatalError() }
        
        print(self.jwt.token!)
           
               // Prepare URL Request Object
        var request = URLRequest(url: requestUrl)
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
                              let classifiedData = try JSONDecoder().decode(ProfileJsonResponse.self, from: data)
                       print(classifiedData.user)
                       if classifiedData.success{
                           DispatchQueue.main.async {
                                self.profile = classifiedData.user
                                print("profile \(self.profile)")

                           }
                       }
                   } catch let error as NSError {
                       print("Failed to load: \(error.localizedDescription)")
                   }
                }
    }
    task.resume()
    }
    
    func EditProfile(username: String, firstName: String, lastName: String, instrumentsPlayed: [String], experience: [String], links: [String]) {
        guard userId == jwt.userId else {return}
        
        // Prepare URL
           let url = URL(string: "https://www.sonarmusic.social/api/users/")
           guard let requestUrl = url else { fatalError() }
           
           // Prepare URL Request Object
           var request = URLRequest(url: requestUrl)
           request.httpMethod = "PATCH"
        
            //set JWT
        request.setValue(self.jwt.token!, forHTTPHeaderField: "Authorization")

        
            //Convert Experience back to milliseconds from 1970
        
           // HTTP Request Parameters which will be sent in HTTP Request Body
        let postString = "username=\(username)&firstName=\(firstName)&lastName=\(lastName)&instrumentsPlayed=\(instrumentsPlayed)&links=\(links)";
           
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
                            print(json)
                       }
                   } catch let error as NSError {
                       print("Failed to load: \(error.localizedDescription)")
                   }

               }

           }
           task.resume()    }
}
