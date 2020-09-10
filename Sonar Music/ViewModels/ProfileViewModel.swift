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
}
