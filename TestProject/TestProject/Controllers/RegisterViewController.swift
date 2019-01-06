//
//  RegisterViewController.swift
//  TestProject
//
//  Created by Yogesh on 05/01/19.
//  Copyright © 2019 Test. All rights reserved.
//

import UIKit
import SVProgressHUD
class RegisterViewController: UIViewController {
    @IBOutlet weak var registerButton: UIButton!
    @IBAction func registerUser(_ sender: Any) {
        self.view.endEditing(true)
        if isAValidUserName(){
            if isAValidEmail(){
                if isAValidPhoneNumber(){
                    if isaValidPassword(){
                        SVProgressHUD.show()
                        ApiManager.sharedInstance.doRegister(emailAddress: emailField.text!, password: passwordField.text!, phoneNumber: phoneField.text!, userName: nameField.text!) { (json, error) in
                            DispatchQueue.main.async {
                                if let err = error {
                                    self.showAlert(message: err.errorMessage, title: err.errortitle)
                                } else{
                                    let array  = json?["data"] as! [[String : Any]]
                                    let json  = array.first
                                    UserDefaults.standard.set(json, forKey: "userData")
                                    UserDefaults.standard.synchronize()
                                    
                                    let controller  = self.storyboard?.instantiateViewController(withIdentifier: "HomeScreenController")
                                    self.present(controller!, animated: true, completion: nil)
                                }
                                SVProgressHUD.dismiss()
                            }
                        }
                    }
                }
            }
        }
    }
    
    private func isAValidUserName()->Bool{
        if let text = nameField.text , text.isEmpty == false{
            return true
        } else{
            self.showAlert(message: "Please Enter a valid name", title: "Message");
        }
        return false
    }
    
    private func isAValidPhoneNumber()->Bool{
        if let text = phoneField.text , text.isEmpty == false , text.count >= 10 {
            return true
        } else{
            self.showAlert(message: "Please Enter a valid Phone Number", title: "Message");
        }
        return false
    }
    
    private func isAValidEmail()->Bool{
        if let text = emailField.text , text.isEmpty == false {
            return text.isAValidEmail()
        } else{
            self.showAlert(message: "Please Enter a valid  Email", title: "Message");
        }
        return false
    }
    
    private func isaValidPassword()->Bool{
        if let text = passwordField.text , text.isEmpty == false, text.count >= 6 {
            return true
        } else{
            self.showAlert(message: "Password length should be greater than 5", title: "Message");
        }
        return false
    }
    
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var phoneField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var nameField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        registerButton.backgroundColor = UIColor(red: 242.0/255.0, green: 242.0/255.0, blue: 242.0/255.0, alpha: 1.0)
        registerButton.layer.cornerRadius = 10
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
