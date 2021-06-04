//
//  AddLocationController.swift
//  OnTheMap
//
//  Created by GOZDE KARDAS on 3.06.2021.
//

import UIKit

class AddLocationController: UIViewController{
    
    @IBOutlet weak var mediaUrl: UITextField!
    @IBOutlet weak var address: UITextField!
    
    @IBAction func findLoc(_ sender: Any) {
        
        
        UdacityClient.getUserInfo{ user, error in
            print(user.firstName)
            
        }
        
        performSegue(withIdentifier: "showLocation", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.destination is FindLocationController {
            let vc = segue.destination as? FindLocationController
            vc?.mediaUrl = mediaUrl.text ?? "-"
            vc?.address = address.text ?? "-"
        }
    }}
