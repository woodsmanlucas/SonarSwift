//
//  ClassifiedsViewModel.swift
//  Sonar Music
//
//  Created by Lucas Johnson on 2020-08-19.
//  Copyright © 2020 Sonar Music. All rights reserved.
//

import SwiftUI

struct ClassifiedJsonResponse: Codable {
    var success: Bool
    var classifieds: [Classified]
}

struct Classified: Codable {
    var _id: String
    var datePosted: Int
    var pictures: [String]
    var tags: [String]
    var title: String
    var description: String
    var type: String
    var yearsOfExperience: String?
    var user: [User?]
}

struct User: Codable {
    var _id: String
    var username: String
    var firstName: String
    var lastName: String
    var lat: Float
    var lng: Float
}

class ClassifiedsViewModel: ObservableObject {
    @Published private(set) var classifieds: [Classified] = []
    @Published private(set) var loaded = false

    func GetClassifieds() {
        // Prepare URL
        let url = URL(string: "https://www.sonarmusic.social/api/classifieds")
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
                print(data)
            do{
                       let classifiedData = try JSONDecoder().decode(ClassifiedJsonResponse.self, from: data)
                print(classifiedData.classifieds)
                if classifiedData.success{
                    DispatchQueue.main.async {
                        self.classifieds = classifiedData.classifieds
                        print("classified \(self.classifieds)")

                    }
                }
            } catch let error as NSError {
                print("Failed to load: \(error.localizedDescription)")
            }

        }

    }
    task.resume()
    }
    
    func CreateClassified(_ jwtToken: String, title: String, description: String, type: String){
        print(type)
    }
}
