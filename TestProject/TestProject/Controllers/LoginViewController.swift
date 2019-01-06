//
//  LoginViewController.swift
//  TestProject
//
//  Created by wooqer on 05/01/19.
//  Copyright © 2019 Test. All rights reserved.
//

import UIKit
import SVProgressHUD

class LoginViewController: UIViewController {

    @IBOutlet weak var signupButtom: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBAction func register(_ sender: Any) {
        passwordField.text = nil;
    }
    
    @IBAction func loginPressed(_ sender: Any) {
        self.view.endEditing(true)
        if userNameField.text?.isEmpty == false {
            if userNameField.text?.isAValidEmail() == true {
                if passwordField.text?.isEmpty == false {
                    if let text = self.passwordField.text, text.count >= 6 {
                        SVProgressHUD.show()
                        ApiManager.sharedInstance.doLogin(emailAddress: userNameField.text!, password: passwordField.text!) { (json, error) in
                            DispatchQueue.main.async {
                                if let err = error {
                                    self.showAlert(message: err.errorMessage, title: err.errortitle)
                                } else{
                                    let array  = json?["data"] as! [Any]
                                     let json  = array.first
                                     UserDefaults.standard.set(json, forKey: "userData")
                                     UserDefaults.standard.synchronize()
                                    
                                    let controller  = self.storyboard?.instantiateViewController(withIdentifier: "HomeScreenController")
                                    self.present(controller!, animated: true, completion: nil)
                                }
                                 SVProgressHUD.dismiss()
                            }
                            
                            
                        }
                    } else{
                        self.showAlert(message: "Password length should be greater than 5", title: "Message");
                    }
                } else{
                     self.showAlert(message: "Please fill a valid password", title: "Message");
                }
            } else{
                self.showAlert(message: "Enter Valid Email", title: "Message");
            }
        } else{
            self.showAlert(message: "Please fill all valid Field", title: "Message");
        }
    }
    
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var userNameField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        loginButton.backgroundColor = UIColor(red: 242.0/255.0, green: 242.0/255.0, blue: 242.0/255.0, alpha: 1.0)
        loginButton.layer.cornerRadius = 10
        
        signupButtom.backgroundColor = UIColor(red: 242.0/255.0, green: 242.0/255.0, blue: 242.0/255.0, alpha: 1.0)
        signupButtom.layer.cornerRadius = 10
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if UserDefaults.standard.value(forKey: "userData") != nil {
            let controller  = self.storyboard?.instantiateViewController(withIdentifier: "HomeScreenController")
            self.present(controller!, animated: true, completion: nil)
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
