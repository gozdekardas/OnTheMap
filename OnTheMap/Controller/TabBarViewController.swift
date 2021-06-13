//
//  TabBarViewController.swift
//  OnTheMap
//
//  Created by GOZDE KARDAS on 3.06.2021.
//


import UIKit

class TabBarController: UITabBarController {
    @IBAction func logout(_ sender: Any) {
        
        
        UdacityClient.logout(){ success, error in
            if success{
                print("logedOut")
                DispatchQueue.main.async {
                    //self.performSegue(withIdentifier: "backtoLogin", sender: nil)
                    self.dismiss(animated: true, completion: nil)
                }
                
            }
        }
        
    }
    
    
    @IBAction func refresh(_ sender: Any) {
        
        UdacityClient.getLocations() { locations, error in
            
            StudentsLocations.data = locations
            print(locations)
        }
        
        
    }
}
