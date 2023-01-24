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
//            postString = "title=\(title)&description=\(description)&tags=\(tags)&pictures=\(imageURLs)&type=\(type)"
struct MyClassifiedJsonResponse: Codable {
    var success: Bool
    var ad: [MyClassified]
}

struct CreateClassifiedJsonWithPrice: Codable {
    var title: String
    var description: String
    var tags: [String]
    var pictures: [String]
    var type: String
    var price: Double
}

struct CreateClassifiedJsonWithoutPrice: Codable {
    var title: String
    var description: String
    var tags: [String]
    var pictures: [String]
    var type: String
}

struct CreateClassifiedJsonResponse: Codable {
    var success: Bool
}



struct CreateClassifiedErrorJsonResponse: Codable {
    var success: Bool
    var err: String
}

struct Classified: Codable {
    var _id: String
    var datePosted: Int
    var pictures: [String]
    var tags: [String]
    var title: String
    var description: String
    var type: String
    var price: Double?
    var yearsOfExperience: String?
    var user: [User?]
}

struct MyClassified: Codable {
    var _id: String
    var datePosted: Int
    var pictures: [String]
    var tags: [String]
    var title: String
    var description: String
    var type: String
    var price: Double?
    var yearsOfExperience: String?
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
    @ObservedObject var jwt: JWT
    
    @Published private(set) var classifieds: [Classified] = []
    @Published private(set) var myClassifieds: [MyClassified] = []
    @Published private(set) var loaded = false
    @Published private(set) var images: [UIImage] = []
    
    private var image: UIImage?
    private var imageURLs: [String] = []
    
    init(jwt: JWT){
        self.jwt = jwt
    }

    func GetClassifieds() {
        // Prepare URL
        let url = URL(string: "http://localhost:4000/api/classifieds")
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
            if let data = data {
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
    
    func CreateClassified(_ jwtToken: String, title: String, description: String, type: String, price: Double?, tags: [String]) -> Result<String?, NetworkError>{
        print(imageURLs)
        
        var result: Result<String?, NetworkError> = .failure(.unknown)
               
               let semaphore = DispatchSemaphore(value: 0)
               
               
               // Prepare URL
               let array: [String] = []
               
                  print("\(array)")
                  let url = URL(string: "http://localhost:4000/api/classifieds/user")
                  guard let requestUrl = url else { fatalError() }
                  
                  // Prepare URL Request Object
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "POST"
        
            //set JWT
        request.setValue(self.jwt.token!, forHTTPHeaderField: "Authorization")
               
                  // HTTP Request Parameters which will be sent in HTTP Request Body
        let postString: String
        
        let imageString = imageURLs.joined(separator: " ")
        
        if(price != nil){
            postString = "title=\(title)&description=\(description)&pictures=\(imageString)&tags=\(tags)&type=\(type)&price=\(price!)";
        }else{
            postString = "title=\(title)&description=\(description)&tags=\(tags)&pictures=\(imageString)&type=\(type)"
        }
        print(postString)


                  // Set HTTP Request Body
                request.httpBody = postString.data(using: String.Encoding.utf8)
        
//                let encoder = JSONEncoder()
//                let jsonData: Data?
//                if(price != nil){
//                    let newClassified = CreateClassifiedJsonWithPrice(title: title, description: description, tags: tags, pictures: imageURLs, type: type, price: price!)
//                    jsonData = try? encoder.encode(newClassified)
//                }else{
//                    let newClassified = CreateClassifiedJsonWithoutPrice(title: title, description: description, tags: tags, pictures: imageURLs, type: type)
//                    jsonData = try? encoder.encode(newClassified)
//                }
            
                // Set HTTP Request Body
//                request.httpBody = jsonData
                  
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
                        let JSONresponse = try JSONDecoder().decode(CreateClassifiedJsonResponse.self, from: data)
                        if(JSONresponse.success){
                            result = .success(nil)
                        }else{
                            let error = try JSONDecoder().decode(CreateClassifiedErrorJsonResponse.self, from: data)
                            result = .success(error.err)
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
    
    func getMyClassifeds(){
        // Prepare URL
        let url = URL(string: "http://localhost:4000/api/classifieds/userAd/" + self.jwt.userId!)
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
                    print(dataString)
                   do{
                       let classifiedData = try JSONDecoder().decode(MyClassifiedJsonResponse.self, from: data)
                       if classifiedData.success{
                           DispatchQueue.main.async {
                               self.myClassifieds = classifiedData.ad
                               print("classified \(self.myClassifieds)")

                           }
                       }
                   } catch let error as NSError {
                       print("Failed to load: \(error.localizedDescription)")
                   }

               }
        }
        task.resume()
    }
    
    func delete(_ classifiedId: String) {
        print(classifiedId)
        
        // Prepare URL
        let url = URL(string: "http://localhost:4000/api/classifieds/user/" + classifiedId)
        guard let requestUrl = url else { fatalError() }
           
        // Prepare URL Request Object
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "DELETE"

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
                    print(dataString)
               }
        }
        task.resume()
        
        
    }
    
    func uploadPhoto(_ image: UIImage, jwt: JWT){
        if(image.pngData() != nil){
        
        let filename = UUID().uuidString + ".png"
        
        let resizedImage = resizeImage(image: image, targetSize: CGSize(width: 200.0, height: 200.0))

        // generate boundary string using a unique per-app string
        let boundary = UUID().uuidString

        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)

        // Set the URLRequest to POST and to the specified URL
        var urlRequest = URLRequest(url: URL(string: "http://localhost:4000/api/upload")!)
        urlRequest.httpMethod = "POST"

        // Set JWT
        urlRequest.setValue(jwt.token!, forHTTPHeaderField: "Authorization")

        
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
                    if (uploadData.file != "" && image.pngData() != nil){
                        DispatchQueue.main.async {
                            self.images.append(image)

                        }
                        self.imageURLs.append("https://www.sonarmusic.social/api/public/" + uploadData.file)
                    }
                    
                    print("Image Urls:")
                    print(self.imageURLs)
                }
            } catch let error as NSError {
                print("Failed to load: \(error.localizedDescription)")
            }
        }).resume()
        }
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
            
        if(newImage != nil){
            return newImage!
        }
        return image
       }
}
