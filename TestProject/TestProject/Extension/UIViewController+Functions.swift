//
//  UIViewController+Functions.swift
//  TestProject
//
//  Created by Yogesh on 05/01/19.
//  Copyright © 2019 Test. All rights reserved.
//

import UIKit
extension UIViewController {
    func showAlert(message : String , title : String) {
        let alertController  = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: Constant.ButtonTitle.koKTitle, style: .cancel, handler: nil)
        alertController.addAction(alertAction)
        present(alertController, animated: true, completion: nil)
    }
}
