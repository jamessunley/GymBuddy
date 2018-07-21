//
//  ProfileUpdateViewController.swift
//  GymBuddy
//
//  Created by James Sunley on 26/02/2018.
//  Copyright © 2018 James Sunley. All rights reserved.
//

import UIKit
import Alamofire
class ProfileUpdateViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var surname: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var goal: UITextField!
    @IBOutlet weak var weight: UITextField!
    @IBOutlet weak var height: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var confirmPassword: UITextField!
    @IBOutlet weak var oldPassword: UITextField!
    let defaultValues = UserDefaults.standard
    override func viewDidLoad() {
        
        if(defaultValues.integer(forKey: "trainer") == 0){
            goal.placeholder = "Personal Goal: "
        }else if(defaultValues.integer(forKey: "trainer") == 1){
            goal.placeholder = "Price: "
        }
        
        self.firstName.delegate = self;
        self.surname.delegate = self;
        self.email.delegate = self;
        self.goal.delegate = self;
        self.height.delegate = self;
        self.weight.delegate = self;
        self.password.delegate = self;
        self.confirmPassword.delegate = self;
        self.oldPassword.delegate = self;
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func updateButtonTapped(_ sender: UIButton) {
        if (oldPassword.text?.isEmpty)!
        {
            //display alert message and return
            displayMessage(userMessage: "Please enter your password")
            return
        }
        var first: String
        var last: String
        var em: String
        var goa: String
        var wei: String
        var hei: String
        var pass: String

        if(firstName.text == nil){
            first = defaultValues.string(forKey: "firstname")!
        }else{
            first = firstName.text!
        }
        if(surname.text == nil){
            last = defaultValues.string(forKey: "surname")!
        }else{
            last = surname.text!
        }
        if(email.text == nil){
            em = defaultValues.string(forKey: "email")!
        }else{
            em = email.text!
        }
        if(goal.text == nil){
            goa = defaultValues.string(forKey: "goalORprice")!
        }else{
            goa = goal.text!
        }
        if(weight.text == nil){
            wei = defaultValues.string(forKey: "weight")!
        }else{
            wei = weight.text!
        }
        if(height.text == nil){
            hei = defaultValues.string(forKey: "height")!
        }else{
            hei = height.text!
        }
        if(password.text == nil || confirmPassword.text == nil){
            pass = oldPassword.text!
        }else{
            pass = password.text!
        }


        //validate password
        if ((password.text?.elementsEqual(confirmPassword.text!))! != true)
        {
            //Display alert message and return
            displayMessage(userMessage: "Passwords do not Match")
            return
        }
        
        //send parameters
        let parameters: Parameters=[
            "username":defaultValues.string(forKey: "username")!,
            "password":oldPassword.text!,
            "newpassword":pass,
            "first": first,
            "surname": last,
            "email": em,
            "goal": goa,
            "weight": wei,
            "height": hei]
        
        //Sending http post request
        
        Alamofire.request("http://94.12.191.140/api_test/v1/update.php", method: .post, parameters: parameters, encoding: URLEncoding()).responseJSON
            {
                response in
                //printing response
                print(response)
                //getting the json value from the server
                if let result = response.result.value {
                    
                    //converting it as NSDictionary
                    let jsonData = result as! NSDictionary
                    
                    //displaying the message to user
                    self.displayMessage(userMessage: (jsonData.value(forKey: "message") as! String?)!)
                }
        }
    }
    
    @IBAction func returnButtonTapped(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
    func displayMessage(userMessage:String)-> Void {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: "Alert", message: userMessage, preferredStyle: .alert)
            
            let OKAction = UIAlertAction(title: "OK", style: .default)
            { (action: UIAlertAction!)in
                print ("OK tapped")
                DispatchQueue.main.async {
                    
                }
            }
            alertController.addAction(OKAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
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
