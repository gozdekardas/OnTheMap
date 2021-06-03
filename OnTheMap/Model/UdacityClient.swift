//
//  UdacityClient.swift
//  OnTheMap
//
//  Created by GOZDE KARDAS on 2.06.2021.
//

import Foundation

class UdacityClient{
    
    
    struct Auth {
        static var accountKey = ""
        static var firstName = ""
        static var lastName = ""
    }
    
    
    //MARK: Endpoints
        enum EndPoints {
            
            static let base = "https://onthemap-api.udacity.com/v1"
            
            case login
            case addLocation
            case getLocations
            case getUserInfo
            
            
            
            var stringValue: String {
                switch self {
                case .login:
                    return EndPoints.base + "/session"
                case .addLocation:
                    return  EndPoints.base + "/StudentLocation"
                case .getLocations:
                    return EndPoints.base + "/StudentLocation?order=-createdAt?limit=100"
                case .getUserInfo:
                    return EndPoints.base + "/users/\(Auth.accountKey)"
                }
            }
            
            var url: URL {
                return URL(string: stringValue)!
            }
        }
    
    class func taskForPOSTRequest<RequestType: Encodable, ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, body: RequestType, completion: @escaping (ResponseType?, Error?) -> Void) {
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try! JSONEncoder().encode(body)
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
    
    class func taskForGETRequestcompletion<ResponseType: Decodable>( url: URL,responseType: ResponseType.Type,completion:@escaping (ResponseType?, Error?) -> Void) {
        
        let request = URLRequest(url: url)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil { // Handle error...
                return
            }
            print(String(data: data!, encoding: .utf8)!)
            
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: data)
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
        
        let body = LoginRequest(udacity: Udacity(username: username, password: password))
        taskForPOSTRequest(url: EndPoints.login.url, responseType: LoginResponse.self ,body: body) { response, error in
            if let response = response {
                print(response)
                Auth.accountKey = response.account.key
                print("account_key")
                print(Auth.accountKey )
                completion(true, nil)
            } else {
                print("false")
                completion(false, error)
            }
        }
    }
    
    
    class func getLocations( completion: @escaping (LocationResult, Error?) -> Void) {
        print("holaa")
        
        taskForGETRequestcompletion(url: EndPoints.getLocations.url, responseType: LocationResult.self) { response, error in
            if let response = response {
                // print(response)
                print("true")
                completion(response, nil)
            }else
            {print(error as Any)}
            
        }
    }
    
    class func postStudenLocation(longitude: Double, latitude: Double, mapString: String, mediaURL: String,completion: @escaping (Bool, Error?) -> Void){
     
        let body = Location(firstName: Auth.firstName, lastName: Auth.lastName, longitude: longitude, latitude: latitude, mapString: mapString, mediaURL: mediaURL, uniqueKey: Auth.accountKey)
        
        var request = URLRequest(url: EndPoints.addLocation.url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try! JSONEncoder().encode(body)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
          if error != nil { // Handle error…
              return
          }
          print(String(data: data!, encoding: .utf8)!)
        }
        task.resume()
        
        
        
        
    }
    
    class func getUserInfo( completion: @escaping (UserDataResponse, Error?) -> Void) {
        
        let request = URLRequest(url: EndPoints.getUserInfo.url)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
          if error != nil { // Handle error...
              return
          }
          let range = (5..<data!.count)
          let newData = data?.subdata(in: range) /* subset response data! */
          print(String(data: newData!, encoding: .utf8)!)
            
            guard let newData = newData else {
                return
            }
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(UserDataResponse.self, from: newData)
                Auth.firstName = responseObject.user.firstName
                Auth.lastName = responseObject.user.lastName
            } catch {
                DispatchQueue.main.async {
                    print(error)
                }
            }
        }
        task.resume()
    }
    
    
}
