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
                return EndPoints.base + "/StudentLocation?limit=100&order=-updatedAt"
            case .getUserInfo:
                return EndPoints.base + "/users/\(Auth.accountKey)"
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
    }
    
    class func taskForPOSTRequest<RequestType: Encodable, ResponseType: Decodable>(removeFirstChars: Bool,url: URL, responseType: ResponseType.Type, body: RequestType, completion: @escaping (ResponseType?, Error?) -> Void) {
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try! JSONEncoder().encode(body)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil { 
                completion(nil, error)
                return
            }
            
            var newData = data
            
            if removeFirstChars {
                let range = (5..<data!.count)
                newData = data?.subdata(in: range)
                
            }
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
    
    class func taskForDELETERequest(url: URL, completion: @escaping (Bool?, Error?) -> Void) {
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
          if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
          request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
          if error != nil { // Handle error…
              return
          }
          
          print(String(data: data!, encoding: .utf8)!)
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            completion(true, nil)
        }
        task.resume()
    }
    
    class func taskForGETRequestcompletion<ResponseType: Decodable>( removeFirstChars: Bool, url: URL,responseType: ResponseType.Type,completion:@escaping (ResponseType?, Error?) -> Void) {
        
        let request = URLRequest(url: url)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil { // Handle error...
                return
            }
            
            var newData = data
            
            if removeFirstChars {
                let range = (5..<data!.count)
                newData = data?.subdata(in: range)
                
            }
            
            print(String(data: newData!, encoding: .utf8)!)
            
            guard let newData = newData else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: newData)
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
    
    class func getUserInfo( completion: @escaping (User, Error?) -> Void) {
        
        taskForGETRequestcompletion(removeFirstChars: true, url: EndPoints.getUserInfo.url, responseType: User.self) { response, error in
            if let response = response {
                Auth.firstName = response.firstName
                Auth.lastName = response.lastName
                completion(response, nil)
            }else
            {print(error as Any)}
            
        }
        
    }
    
    class func login(username: String, password: String, completion: @escaping (Bool, Error?) -> Void) {
        
        let body = LoginRequest(udacity: Udacity(username: username, password: password))
        taskForPOSTRequest(removeFirstChars: true, url: EndPoints.login.url, responseType: LoginResponse.self ,body: body) { response, error in
            if let response = response {
                Auth.accountKey = response.account.key
                completion(true, nil)
            } else {
                completion(false, error)
            }
        }
    }
    
    class func logout(completion: @escaping (Bool, Error?) -> Void) {
        
        
        taskForDELETERequest(url: EndPoints.login.url){ response, error in
            if let response = response {
                completion(true, nil)
            } else {
                completion(false, error)
            }
        }
    }
    
    
    class func getLocations(  completion: @escaping ([Location], Error?) -> Void) {
        
        taskForGETRequestcompletion(removeFirstChars: false, url: EndPoints.getLocations.url, responseType: LocationResult.self) { response, error in
            if let response = response {
                
                completion(response.results, nil)
            }else
            {print(error as Any)}
            
        }
    }
    
    class func postStudenLocation(longitude: Double, latitude: Double, mapString: String, mediaURL: String,completion: @escaping (Bool, Error?) -> Void){
        
        let body = Location(firstName: Auth.firstName, lastName: Auth.lastName, longitude: longitude, latitude: latitude, mapString: mapString, mediaURL: mediaURL, uniqueKey: Auth.accountKey)
        
        taskForPOSTRequest(removeFirstChars: false, url: EndPoints.addLocation.url, responseType: PostLocationResponse.self ,body: body) { response, error in
            if let response = response {
                completion(true, nil)
            } else {
                completion(false, error)
            }
        }
    }
}
