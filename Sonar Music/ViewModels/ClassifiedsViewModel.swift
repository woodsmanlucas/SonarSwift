//
//  ClassifiedsViewModel.swift
//  Sonar Music
//
//  Created by Lucas Johnson on 2020-08-19.
//  Copyright © 2020 Sonar Music. All rights reserved.
//

import SwiftUI

struct Classified {
    var _id: String
    var datePosted: Int
    var pictures: [String]
    var tags: [String]
    var title: String
    var description: String
    var type: String
    var yearsOfExperience: String
    var userId: String
    var user: User
}

struct User {
    var _id: String
    var experience: [Int]
    var instrumentsPlayed: [String]
    var links: [String]
    var genre: [String]
    var username: [String]
    var lat: Float
    var lng: Float
}

class ClassifiedsViewModel: ObservableObject {
    @Published private(set) var classifieds: [Classified] = []
    @Published private(set) var loaded = false

    func GetClassifieds() {
        // Prepare URL
        let url = URL(string: "http://www.sonarmusic.social/api/classifieds")
        guard let requestUrl = url else { fatalError() }
    
        // Prepare URL Request Object
        let request = URLRequest(url: requestUrl)
 
    
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
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [Classified] {
                    if let classifieds = json["classifieds"] as? [Classified]{
                        print("addsf")
                        DispatchQueue.main.async {
                            self.classifieds = classifieds
                            self.loaded = true
                        }
                        print(self.classifieds)
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
