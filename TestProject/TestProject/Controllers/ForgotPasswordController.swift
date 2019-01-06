//
//  ForgotPasswordController.swift
//  TestProject
//
//  Created by wooqer on 05/01/19.
//  Copyright © 2019 Test. All rights reserved.
//

import UIKit
import SVProgressHUD
class ForgotPasswordController: UIViewController {

    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var emailField: UITextField!
    
    @IBAction func submit(_ sender: Any) {
        self.view.endEditing(true)
        if let text = emailField.text , text.isEmpty == false , text.isAValidEmail() {
            SVProgressHUD.show()
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
                SVProgressHUD.dismiss()
                self.showAlert(message: "An email containing information on how to reset your password has been sent.", title: "Password Reset")
            })
          
        } else{
            self.showAlert(message: "Please enter valid email address", title: "Message")
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        submitButton.backgroundColor = UIColor(red: 242.0/255.0, green: 242.0/255.0, blue: 242.0/255.0, alpha: 1.0)
        submitButton.layer.cornerRadius = 10
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
