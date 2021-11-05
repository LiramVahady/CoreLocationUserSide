//
//  Extenssion+UIViewController.swift
//  UserLocationDemo
//
//  Created by me on 04/11/2021.
//

import Foundation
import UIKit

extension UIViewController{
    
    func appearDialogToUser(title: String,message: String){
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
}
