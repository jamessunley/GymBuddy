//
//  NewsDetailViewController.swift
//  GymBuddy
//
//  Created by James Sunley on 22/02/2018.
//  Copyright © 2018 James Sunley. All rights reserved.
//

import UIKit
import Foundation

class NewsDetailViewController: UIViewController {
    

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var trainerLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    var selectedNews : NewsModel?

    override func viewDidLoad() {
        titleLabel.text = selectedNews!.title
        trainerLabel.text = "Written by: " + selectedNews!.trainer!
        contentLabel.text = selectedNews!.content
        contentLabel.lineBreakMode = .byWordWrapping
        contentLabel.numberOfLines = 0
        contentLabel.sizeToFit()
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
