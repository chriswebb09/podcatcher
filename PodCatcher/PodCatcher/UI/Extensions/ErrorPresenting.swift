//
//  ErrorPresenting.swift
//  PodCatcher
//
//  Created by Christopher Webb-Orenstein on 1/12/18.
//  Copyright © 2018 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit

protocol ErrorPresenting {
    func presentError(title: String, message: String)
}

extension ErrorPresenting where Self: UIViewController {
    func presentError(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(dismissAction)
        present(alertController, animated: true)
    }
}

