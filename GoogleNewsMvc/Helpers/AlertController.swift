//
//  AlertController.swift
//  GoogleNewsMvc
//
//  Created by Mr. T. on 29.02.2020.
//  Copyright © 2020 Mr. T. All rights reserved.
//

import Foundation
import UIKit

class AlertController {
    
    static func presentAlert(title: String, message: String, cancelMsg: String) -> UIAlertController{
        let alertView = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertView.addAction(UIAlertAction(title: cancelMsg, style: .cancel, handler: nil))
        return alertView
    }
}
