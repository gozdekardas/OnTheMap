//
//  TabBarViewController.swift
//  OnTheMap
//
//  Created by GOZDE KARDAS on 3.06.2021.
//


import UIKit

class TabBarController: UITabBarController {
    @IBAction func logout(_ sender: Any) {

        var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/session")!)
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
          let range = (5..<data!.count)
          let newData = data?.subdata(in: range) /* subset response data! */
          print(String(data: newData!, encoding: .utf8)!)
        }
        task.resume()
        
        if let nav = self.navigationController {
                nav.popViewController(animated: true)
            } else {
                self.dismiss(animated: true, completion: nil)
            }
        
        
        
    }
    
    @IBAction func refresh(_ sender: Any) {
        
        UdacityClient.getLocations() { locations, error in
            
            let locations = locations.results
            print("olacak mi")
            (UIApplication.shared.delegate as! AppDelegate).userLocations.append(contentsOf: locations)
            print("oldi")
            print(locations)
            print("olmistir")
        }
        
        
    }
    @IBAction func addLocation(_ sender: Any) {
    }
}
