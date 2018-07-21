//
//  ViewController.swift
//  GymBuddy
//
//  Created by James Sunley on 29/01/2018.
//  Copyright © 2018 James Sunley. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidAppear(_ animated: Bool) {
        self.performSegue( withIdentifier: "loginView", sender: self)
    }

}

