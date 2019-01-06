//
//  UIViewController+Functions.swift
//  TestProject
//
//  Created by Yogesh on 08/12/18..
//  Copyright © 2018 Test. All rights reserved.
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
