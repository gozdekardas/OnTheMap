//
//  ViewController.swift
//  OnTheMap
//
//  Created by GOZDE KARDAS on 2.06.2021.
//

import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func logIn(_ sender: Any) {
     //   UdacityClient.login(username: emailTextField.text ?? "", password: passwordTextField.text ?? "", completion: handleLoginResponse(success:error:))
    }
    
    func handleLoginResponse(success: Bool, error: Error?) {
        
        if success {
            
            print("okdir")
            
            let VC1 = self.storyboard!.instantiateViewController(withIdentifier: "MapViewController") as! MapViewController
            let navController = UINavigationController(rootViewController: VC1)
            // Creating a navigation controller with VC1 at the root of the navigation stack.
            self.present(navController, animated:true, completion: nil)
            // Instantiating the second view controller
          
            
            
            
            
             
        } else {
            showLoginFailure(message: "Incorrect Username or Password ")
        }
    }
    
    func showLoginFailure(message: String) {
        let alertVC = UIAlertController(title: "Login Failed", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        show(alertVC, sender: nil)
    }
}

