//
//  ProfileViewController.swift
//  GymBuddy
//
//  Created by James Sunley on 26/02/2018.
//  Copyright © 2018 James Sunley. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var helloLabel: UILabel!
    @IBOutlet weak var goalLabel: UILabel!
    @IBOutlet weak var bmiLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var availabilityButton: UIButton!
    override func viewDidLoad() {
        let defaultValues = UserDefaults.standard
        
        if(defaultValues.integer(forKey: "trainer") == 0){
            let bmiresult = bmi(height: defaultValues.double(forKey: "height"), weight: defaultValues.double(forKey: "weight"))
            
            helloLabel.text = "Hello " + defaultValues.string(forKey: "firstname")!
            goalLabel.text = "Your current goal is: " + defaultValues.string(forKey: "goalORprice")!
            goalLabel.lineBreakMode = .byWordWrapping
            goalLabel.numberOfLines = 0
            goalLabel.sizeToFit()
            bmiLabel.text = bmiresult
            bmiLabel.lineBreakMode = .byWordWrapping
            bmiLabel.numberOfLines = 0
            bmiLabel.sizeToFit()
            priceLabel.text = "Thank you for using Gym Buddy. Developed by James Sunley"
            priceLabel.lineBreakMode = .byWordWrapping
            priceLabel.numberOfLines = 0
            priceLabel.sizeToFit()
            availabilityButton.isHidden = true
            
        }else if(defaultValues.integer(forKey: "trainer") == 1){
            let bmiresult = bmi(height: defaultValues.double(forKey: "height"), weight: defaultValues.double(forKey: "weight"))
            
            helloLabel.text = "Hello " + defaultValues.string(forKey: "firstname")!
            goalLabel.text = "Your current price is: " + defaultValues.string(forKey: "goalORprice")!
            goalLabel.lineBreakMode = .byWordWrapping
            goalLabel.numberOfLines = 0
            goalLabel.sizeToFit()
            bmiLabel.text = "Your BMI is " + bmiresult
            bmiLabel.lineBreakMode = .byWordWrapping
            bmiLabel.numberOfLines = 0
            bmiLabel.sizeToFit()
            priceLabel.text = "Thank you for using Gym Buddy. Developed by James Sunley"
            priceLabel.lineBreakMode = .byWordWrapping
            priceLabel.numberOfLines = 0
            priceLabel.sizeToFit()
            availabilityButton.isHidden = false
        }
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    public func bmi(height: Double, weight: Double) -> String{
        let meters = height/100
        let result = weight/meters
        let final = result / meters
        let round = (final * 100).rounded() / 100
        let stringFromDouble = "\(round)"
        var labelText = ""
        if (round <= 18.5){
            labelText = "Your BMI is: " + stringFromDouble + ". This means you are underweight."
        }else if(round > 18.5 && round <= 24.9){
            labelText = "Your BMI is: " + stringFromDouble + ". This means you are of a healthy weight"
        }else if (round >= 25 && round <= 29.9 ){
            labelText = "Your BMI is: " + stringFromDouble + ". This means you are overweight"
        }else if(round >= 30 && round <= 39.9){
            labelText = "Your BMI is: " + stringFromDouble + ". This means you are obese"
        }
        return labelText
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func progressButtonTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "progressSegue", sender: self)
    }
    
    @IBAction func updateButtonTapped(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "updateSegue", sender: self)
    }
    @IBAction func signOutButtonTapped(_ sender: Any) {
        //removing values from default
        UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
        UserDefaults.standard.synchronize()
        
        //switching to login screen
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let LogInViewController = storyboard.instantiateViewController(withIdentifier: "LogInViewController") as! LogInViewController
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = LogInViewController
    }
    @IBAction func availabilityButtonTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "availabilitySegue", sender: self)
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
