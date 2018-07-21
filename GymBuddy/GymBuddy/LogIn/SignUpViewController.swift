//
//  SignUpViewController.swift
//  GymBuddy
//
//  Created by James Sunley on 08/02/2018.
//  Copyright © 2018 James Sunley. All rights reserved.
//

import UIKit
import Alamofire

class SignUpViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var surnameTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var goalTextField: UITextField!
    @IBOutlet weak var weightTextField: UITextField!
    @IBOutlet weak var heightTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var repeatPasswordTextField: UITextField!
    @IBOutlet weak var dob: UIDatePicker!
    @IBOutlet weak var trainerSwitch: UISwitch!
    
    var trainer = 0;
    @IBAction func trainerSwitch(_ sender: UISwitch) {
        if(sender.isOn){
            trainer = 1
            goalTextField.placeholder = "Price per hour: "
            
            let alertController = UIAlertController(title: "Alert", message: "Enter trainer verification code: ", preferredStyle: .alert)
            
            let OKAction = UIAlertAction(title: "Confirm", style: .default)
            { [weak alertController] _ in
                if let alertController = alertController {
                    let textField = alertController.textFields![0] as UITextField
                
                    if (textField.text != "1234"){
                        
                        self.trainerSwitch.setOn(false, animated: true)
                        
                        let alertController2 = UIAlertController(title: "Alert", message: "Incorrect Trainer code. Please Contact Michael Marshall", preferredStyle: .alert)
                        
                        let doneAction = UIAlertAction(title: "OK", style: .default){[weak alertController2] _ in
                            
                        }
                        alertController2.addAction(doneAction)

                        self.present(alertController2, animated: true, completion: nil)
                    }
                }
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
                self.trainerSwitch.setOn(false, animated: true)
            }
            
            alertController.addTextField { textField in
                textField.placeholder = "Trainer Code"
                NotificationCenter.default.addObserver(forName: NSNotification.Name.UITextFieldTextDidChange, object: textField, queue: OperationQueue.main) { notification in
                    OKAction.isEnabled = textField.text != ""
                }
            }
            alertController.addAction(OKAction)
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
            
        }else {
            trainer = 0
            
            goalTextField.placeholder = "Personal Goal: "
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //sets minimum and maximum on date picker
        let currentDate: Date = Date()
        var calendar: Calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        calendar.timeZone = TimeZone(identifier: "UTC")!
        var components: DateComponents = DateComponents()
        components.calendar = calendar
        //youngest age set to 18
        components.year = -18
        let maxDate: Date = calendar.date(byAdding: components, to: currentDate)!
        components.year = -150
        let minDate: Date = calendar.date(byAdding: components, to: currentDate)!
        dob.minimumDate = minDate
        dob.maximumDate = maxDate
        
        self.usernameTextField.delegate = self;
        self.firstNameTextField.delegate = self;
        self.surnameTextField.delegate = self;
        self.emailTextField.delegate = self;
        self.goalTextField.delegate = self;
        self.heightTextField.delegate = self;
        self.weightTextField.delegate = self;
        self.passwordTextField.delegate = self;
        self.repeatPasswordTextField.delegate = self;

        // Do any additional setup after loading the view.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signUpButtonTapped(_ sender: UIButton) {
        print ("signup tapped")
        
        //validate that text fields are not empty
        if (firstNameTextField.text?.isEmpty)! ||
            (surnameTextField.text?.isEmpty)! ||
            (usernameTextField.text?.isEmpty)! ||
            (emailTextField.text?.isEmpty)! ||
            (passwordTextField.text?.isEmpty)! ||
            (repeatPasswordTextField.text?.isEmpty)! ||
            (goalTextField.text?.isEmpty)! ||
            (weightTextField.text?.isEmpty)! ||
            (heightTextField.text?.isEmpty)!
        {
            //display alert message and return
            displayMessage(userMessage: "All text Fields must be filled")
            return
        }
        
        //validate password
        if ((passwordTextField.text?.elementsEqual(repeatPasswordTextField.text!))! != true)
        {
            //Display alert message and return
            displayMessage(userMessage: "Passwords do not Match")
            return
        }
        
        //create activity indicator
        let myActivityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)

        //position activity Indicator in center
        myActivityIndicator.center = view.center
        myActivityIndicator.hidesWhenStopped = false

        //start activity indicator
        myActivityIndicator.startAnimating()

        view.addSubview(myActivityIndicator)
        
        //send HTTP Request
        //let URL_USER_REGISTER = "http://127.0.0.1/~jamessunley/API/v1/register"
//        let URL_USER_REGISTER = "https://blooming-fjord-72225.herokuapp.com/v1/register.php"
        
//        let URL_USER_REGISTER = "http://192.168.1.4/api_test/v1/register.php"
        let URL_USER_REGISTER = "http://94.12.191.140/api_test/v1/register.php"
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        let date = formatter.string(from: dob.date)
        print(date)
        //send parameters
        let parameters: Parameters=[
            "username":usernameTextField.text!,
            "password":passwordTextField.text!,
            "trainer": trainer,
            "first": firstNameTextField.text!,
            "surname": surnameTextField.text!,
            "email": emailTextField.text!,
            "dob": date,
            "goal": goalTextField.text!,
            "weight": weightTextField.text!,
            "height": heightTextField.text!]
        
        //Sending http post request

        Alamofire.request(URL_USER_REGISTER, method: .post, parameters: parameters, encoding: URLEncoding()).responseJSON
            {
                response in
                //printing response
                print(response)
                //getting the json value from the server
                if let result = response.result.value {
                    
//                    converting it as NSDictionary
                    let jsonData = result as! NSDictionary
                    
//                    displaying the message to user
                    self.displayMessage(userMessage: (jsonData.value(forKey: "message") as! String?)!)
                    
                    self.removeActivityIndicator(activityIndicator: myActivityIndicator)
                }
        }
    }
    
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        
        print ("cancel tapped")
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func removeActivityIndicator(activityIndicator: UIActivityIndicatorView)
    {
        DispatchQueue.main.async {
            activityIndicator.stopAnimating()
            activityIndicator.removeFromSuperview()
        }
    }
    
    func displayMessage(userMessage:String)-> Void {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: "Alert", message: userMessage, preferredStyle: .alert)
            
            let OKAction = UIAlertAction(title: "OK", style: .default)
            { (action: UIAlertAction!)in
                print ("OK tapped")
                DispatchQueue.main.async {
                    self.dismiss(animated: true, completion: nil)
                }
            }
            alertController.addAction(OKAction)
            self.present(alertController, animated: true, completion: nil)
        }
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
