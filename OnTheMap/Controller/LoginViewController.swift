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
        UdacityClient.login(username: emailTextField.text ?? "", password: passwordTextField.text ?? "", completion: handleLoginResponse(success:error:))
        
    }
    
    func handleLoginResponse(success: Bool, error: Error?) {
        
        if success {
            
            print("user?")
            UdacityClient.getUserInfo{ user, error in
                print(user.user.firstName)
            }
            
            
            
            
            performSegue(withIdentifier: "completeLogin", sender: nil)
        } else {
            showLoginFailure(message: "Incorrect Username or Password ")
        }
    }
    
    func showLoginFailure(message: String) {
        let alertVC = UIAlertController(title: "Login Failed", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        show(alertVC, sender: nil)
    }
    @IBAction func signUp(_ sender: Any) {
        let app = UIApplication.shared
        let toOpen = "https://auth.udacity.com/sign-up"
        app.openURL(URL(string: toOpen)!)
        
    }
}

