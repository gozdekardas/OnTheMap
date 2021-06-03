//
//  UdacityClient.swift
//  OnTheMap
//
//  Created by GOZDE KARDAS on 2.06.2021.
//

import Foundation

class UdacityClient{
    
    
    class func taskForPOSTRequest<RequestType: Encodable, ResponseType: Decodable>(username: String, password: String, responseType: ResponseType.Type,body: RequestType, completion: @escaping (ResponseType?, Error?) -> Void) {
        
        var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/session")!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        // encoding a JSON body from a string, can also use a Codable struct
        request.httpBody = try! JSONEncoder().encode(body)
        // "{\"udacity\": {\"username\": \"gozde.kardas@turkcell.com.tr\", \"password\": \"gozdeturkcell\"}}".data(using: .utf8)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
          if error != nil { // Handle error…
              return
          }
          let range = 5..<data!.count
          let newData = data?.subdata(in: range) /* subset response data! */
          print(String(data: newData!, encoding: .utf8)!)
            
            guard let newData = newData else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            let decoder = JSONDecoder()
            print("now")
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: newData)
                print("yes")
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
            
        }
        task.resume()
    }
    
    class func taskForGETRequestcompletion<ResponseType: Decodable>( responseType: ResponseType.Type,completion:@escaping (ResponseType?, Error?) -> Void) {
        let request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/StudentLocation?order=-updatedAt?limit=100")!)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
          if error != nil { // Handle error...
              return
          }
     //     print(String(data: data!, encoding: .utf8)!)
            
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: data)
                print("yes")
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch {
                DispatchQueue.main.async {
                    print(error)
                    completion(nil, error)
                }
            }
        }
        task.resume()
    }
    
    class func login(username: String, password: String, completion: @escaping (Bool, Error?) -> Void) {
        print("hey")
        let body = LoginRequest(udacity: Udacity(username: username, password: password))
        print("hola")
        taskForPOSTRequest(username: username,password:password,responseType: LoginResponse.self ,body: body) { response, error in
            if let response = response {
               print(response)
                print("true")
                completion(true, nil)
            } else {
                print("false")
                completion(false, error)
            }
        }
    }
    
    
    class func getLocations( completion: @escaping (LocationResult, Error?) -> Void) {
       
       
        taskForGETRequestcompletion(responseType: LocationResult.self) { response, error in
            if let response = response {
              // print(response)
                print("true")
                completion(response, nil)
            } 
        }
    }
    
    
}
