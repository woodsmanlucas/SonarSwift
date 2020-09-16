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

struct RatingJsonResponse: Codable, Equatable {
    static func == (lhs: RatingJsonResponse, rhs: RatingJsonResponse) -> Bool {
        if(lhs.success && rhs.success && lhs.average == rhs.average && lhs.data == rhs.data){
            return true
        }else{
            return false
        }
    }
    
    var success: Bool
    var average: Double
    var data: [Rating]
}

struct Rating: Codable, Equatable {
    var comments: String
    var rating: Double
}


class UserViewModel: ObservableObject {
    @ObservedObject var jwt: JWT
    @Published private(set) var profile: [Profile] = []
    @Published private(set) var loaded = false
    @Published var userId: String
    @Published var ratings: RatingJsonResponse?
    
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
    
    func GetRatings(){
                        let url = URL(string: ("https://www.sonarmusic.social/api/ratings/" + userId))
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
                       do{
                                  let classifiedData = try JSONDecoder().decode(RatingJsonResponse.self, from: data)
                           print(classifiedData)
                           if classifiedData.success{
                               DispatchQueue.main.async {
                                    self.ratings = classifiedData
                                print("ratings \(classifiedData)")

                               }
                           }
                       } catch let error as NSError {
                           print("Failed to load: \(error.localizedDescription)")
                       }
                    }
        }
        task.resume()    }
    
    func uploadPhoto(_ image: UIImage){
        print("hello")
        
        
        
        
                let profilePicUrl = "https://www.sonarmusic.social/image"
        
                guard userId == jwt.userId else {return}
                
                // Prepare URL
                   let url = URL(string: "https://www.sonarmusic.social/api/users/")
                   guard let requestUrl = url else { fatalError() }
                   
                   // Prepare URL Request Object
                   var request = URLRequest(url: requestUrl)
                   request.httpMethod = "PATCH"
                
                    //set JWT
                request.setValue(self.jwt.token!, forHTTPHeaderField: "Authorization")
                
                   // HTTP Request Parameters which will be sent in HTTP Request Body
                let postString = "profilePicUrl=\(profilePicUrl)";
        
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
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
//           // HTTP Request Parameters which will be sent in HTTP Request Body
//        let postString = "username=\(username)&firstName=\(firstName)&lastName=\(lastName)&instrumentsPlayed=\(instrumentsPlayed)&links=\(links)";
//
//           // Set HTTP Request Body
//           request.httpBody = postString.data(using: String.Encoding.utf8);
        
        // your post request data
        let postDict : [String: Any] = ["username": username,
                                        "firstName": firstName,
                                        "lastName": lastName,
                                        "links": links]

        guard let postData = try? JSONSerialization.data(withJSONObject: postDict, options: []) else {
            return
        }
        
        print(postDict)

        request.httpBody = postData
        
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
           task.resume()
        
    }
}
