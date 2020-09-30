//
//  ProfileViewModel.swift
//  Sonar Music
//
//  Created by Lucas Johnson on 2020-09-10.
//  Copyright © 2020 Sonar Music. All rights reserved.
//

import SwiftUI
import MapKit

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
    var lat: Double?
    var lng: Double?
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

struct UploadJsonResponse: Codable {
    var success: Bool
    var file: String
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
    var location: CLLocationCoordinate2D?
    
    init(_ user_id: String, jwt: JWT){
        self.userId = user_id
        self.jwt = jwt
    }
    
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size

        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height

        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }

        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)

        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage!
    }
    
    func getBase64Image(image: UIImage, complete: @escaping (String?) -> ()) {
          DispatchQueue.main.async {
              let imageData = image.pngData()
              let base64Image = imageData?.base64EncodedString(options: .lineLength64Characters)
              complete(base64Image)
          }
      }
    
    func postProfilePicUrl(profilePicUrl: String){

        guard userId == jwt.userId else {return}

        let parameters = "{\n    \"profilePicUrl\":\"\(profilePicUrl)\"\n}"
        let postData = parameters.data(using: .utf8)

        var request = URLRequest(url: URL(string: "https://www.sonarmusic.social/api/users")!,timeoutInterval: Double.infinity)
        request.addValue(self.jwt.token!, forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        request.httpMethod = "PATCH"
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
    
    func GetProfile() {
                // prepare URL
                let url = URL(string: ("https://www.sonarmusic.social/api/users/" + userId))
               guard let requestUrl = url else { fatalError() }
        
        print(self.userId)
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
    
    func updateLocation() {
        guard userId == jwt.userId else {return}
        guard location != nil else {return}
                
                // Prepare URL
                   let url = URL(string: "https://www.sonarmusic.social/api/users/")
                   guard let requestUrl = url else { fatalError() }
                   
                   // Prepare URL Request Object
                   var request = URLRequest(url: requestUrl)
                   request.httpMethod = "PATCH"
                
                    //set JWT
                request.setValue(self.jwt.token!, forHTTPHeaderField: "Authorization")
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")

                   // HTTP Request Parameters which will be sent in HTTP Request Body
        let postString = "{\n    \"lat\": \"\(location!.latitude)\",\"lng\": \"\(location!.longitude)\"\n}"
                
        //        "&instrumentsPlayed=\(instrumentsPlayed)&experience=\(experienceConverted)&links=\(links)";

                   // Set HTTP Request Body
                request.httpBody = postString.data(using: .utf8);
                
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
    
    func DeleteProfile() {
                guard userId == jwt.userId else {return}
                
                // Prepare URL
                   let url = URL(string: "https://www.sonarmusic.social/api/users/")
                   guard let requestUrl = url else { fatalError() }
                   
                   // Prepare URL Request Object
                   var request = URLRequest(url: requestUrl)
                   request.httpMethod = "DELETE"
                
                    //set JWT
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
    
    func PostRatings(comment: String, rating: String) -> Bool{
        let sem = DispatchSemaphore.init(value: 0)
        
        
        let url = URL(string: ("https://www.sonarmusic.social/api/ratings/"))
               guard let requestUrl = url else { fatalError() }
                   
               // Prepare URL Request Object
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "POST"
                request.setValue(self.jwt.token!, forHTTPHeaderField: "Authorization")

                        
            let postString = "comment=\(comment)&rating=\(rating)&userBeingRated=\(self.userId)";
                   // Set HTTP Request Body
                   request.httpBody = postString.data(using: String.Encoding.utf8);
        
               // Perform HTTP Request
               let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                    defer { sem.signal() }
                
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
        
        sem.wait()
        return true
    }
    
    func uploadPhoto(_ image: UIImage){
        if(image.pngData() != nil){
        print("hello")
        
        let filename = UUID().uuidString + ".png"
        
        let resizedImage = resizeImage(image: image, targetSize: CGSize(width: 200.0, height: 200.0))

        // generate boundary string using a unique per-app string
        let boundary = UUID().uuidString

        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)

        // Set the URLRequest to POST and to the specified URL
        var urlRequest = URLRequest(url: URL(string: "https://www.sonarmusic.social/api/upload")!)
        urlRequest.httpMethod = "POST"

        // Set JWT
        urlRequest.setValue(self.jwt.token!, forHTTPHeaderField: "Authorization")

        
        // Set Content-Type Header to multipart/form-data, this is equivalent to submitting form data with file upload in a web browser
        // And the boundary is also set here
        urlRequest.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        var data = Data()

        // Add the image data to the raw http request data
        data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"file\"; filename=\"\(filename)\"\r\n".data(using: .utf8)!)
        data.append("Content-Type: image/png\r\n\r\n".data(using: .utf8)!)
        data.append(resizedImage.pngData()!)

        // End the raw http request data, note that there is 2 extra dash ("-") at the end, this is to indicate the end of the data
        // According to the HTTP 1.1 specification https://tools.ietf.org/html/rfc7230
        data.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)

        // Send a POST request to the URL, with the data we created earlier
        session.uploadTask(with: urlRequest, from: data, completionHandler: { responseData, response, error in
            
            if(error != nil){
                print("\(error!.localizedDescription)")
            }
            
            guard let responseData = responseData else {
                print("no response data")
                return
            }
            
            if let responseString = String(data: responseData, encoding: .utf8) {
                print("uploaded to: \(responseString)")
            }
            
            do{
                let uploadData = try JSONDecoder().decode(UploadJsonResponse.self, from: responseData)
                print(uploadData)
                if uploadData.success{
                        print("upload \(uploadData.file)")
                    self.postProfilePicUrl(profilePicUrl: "https://www.sonarmusic.social/api/public/" + uploadData.file)
                }
            } catch let error as NSError {
                print("Failed to load: \(error.localizedDescription)")
            }
        }).resume()
        }
    }
  
    
    
    
     
        
    func EditProfile(username: String, firstName: String, lastName: String, instrumentsPlayed: [String], experiences: [String], links: [String]) {
        guard userId == jwt.userId else {return}
        
        // Prepare URL
           let url = URL(string: "https://www.sonarmusic.social/api/users/")
           guard let requestUrl = url else { fatalError() }
           
           // Prepare URL Request Object
           var request = URLRequest(url: requestUrl)
           request.httpMethod = "PATCH"
        
            //set JWT
        request.setValue(self.jwt.token!, forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        
        
        var experienceConverted: [Int] = []
        let calendar = Calendar.current

        let today = NSDate()
        let january1970 = NSDate(timeIntervalSince1970: 0)
        
        let secondsFrom1970 = calendar.dateComponents([.second], from: january1970 as Date, to: today as Date)

            //Convert Experience back to milliseconds from 1970
        experiences.forEach { experience in
            experienceConverted.append(secondsFrom1970.second!*1000 - Int((Double(experience)!*31556952000.0)))
        }        

           // HTTP Request Parameters which will be sent in HTTP Request Body
        let postString = "{\n    \"firstName\": \"\(firstName)\",\"username\": \"\(username)\",\"lastName\":\"\(lastName)\",\"instrumentsPlayed\":\(instrumentsPlayed),\"experience\":\(experienceConverted),\"links\":\(links)\n}"
        
           // Set HTTP Request Body
        request.httpBody = postString.data(using: .utf8);
        
//        // your post request data
//        let postDict : [String: Any] = ["username": username,
//                                        "firstName": firstName,
//                                        "lastName": lastName,
//                                        "links": links,
//                                        "instrumentsPlayed":instrumentsPlayed,
//                                        "experience":experienceConverted]
//
//        guard let postData = try? JSONSerialization.data(withJSONObject: postDict, options: []) else {
//            return
//        }
//
//        print(postDict)

//        request.httpBody = postData
        
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
