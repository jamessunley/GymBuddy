//
//  LogInViewController.swift
//  GymBuddy
//
//  Created by James Sunley on 05/02/2018.
//  Copyright © 2018 James Sunley. All rights reserved.
//

import UIKit
import Alamofire

class LogInViewController: UIViewController, UITextFieldDelegate {
    
    //The login script url make sure to write the ip instead of localhost
    //you can get the ip using ifconfig command in terminal
    //let URL_USER_LOGIN = "http://127.0.0.1/~jamessunley/API/v1/login"
    //let URL_USER_LOGIN = "https://blooming-fjord-72225.herokuapp.com/v1/login.php"
    //let URL_USER_LOGIN = "http://192.168.1.4/api_test/v1/login.php"
    let URL_USER_LOGIN = "http://94.12.191.140/api_test/v1/login.php"
    
    //the defaultvalues to store user data
    let defaultValues = UserDefaults.standard

    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var userPasswordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: navigationController, action: nil)
        navigationItem.leftBarButtonItem = backButton
        
        // Do any additional setup after loading the view, typically from a nib.
        
        //if user is already logged in switching to profile screen
        if defaultValues.string(forKey: "username") != nil{
            let homeViewController = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
            self.navigationController?.pushViewController(homeViewController, animated: true)
        }
        
        self.userNameTextField.delegate = self;
        self.userPasswordTextField.delegate = self;
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func logInButtonTapped(_ sender: Any) {
        print ("sign in tapped")
        
        //getting the username and password
        let parameters: Parameters=[
            "username":userNameTextField.text!,
            "password":userPasswordTextField.text!
        ]
        
        //making a post request
        Alamofire.request(URL_USER_LOGIN, method: .post, parameters: parameters).responseJSON
            {
                response in
                //printing response
                print(response)
                
                //getting the json value from the server
                if let result = response.result.value {
                    let jsonData = result as! NSDictionary
                    
                    //if there is no error
                    if(!(jsonData.value(forKey: "error") as! Bool)){
                        
                        //getting the user from response
                        let user = jsonData.value(forKey: "user") as! NSDictionary
                        let detail = jsonData.value(forKey: "detail") as! NSDictionary
                        //getting user values
                        let userId = user.value(forKey: "id") as! Int
                        let userName = user.value(forKey: "username") as! String
                        let trainer = user.value(forKey: "trainer") as! Int
                        let first = detail.value(forKey: "firstname") as! String
                        let surname = detail.value(forKey: "surname") as! String
                        let email = detail.value(forKey: "email") as! String
                        let dob = detail.value(forKey: "dob") as! String
                        
                        if (trainer == 1){
                            let goal = detail.value(forKey: "goal") as! Int
                            self.defaultValues.set(goal, forKey: "goalORprice")
                        }else{
                            let goal = detail.value(forKey: "goal") as! String
                            self.defaultValues.set(goal, forKey: "goalORprice")
                        }
                        
                        let weight = detail.value(forKey: "weight") as! Double
                        let height = detail.value(forKey: "height") as! Double
                        
                        //saving user values to defaults
                        self.defaultValues.set(userId, forKey: "userid")
                        self.defaultValues.set(userName, forKey: "username")
                        self.defaultValues.set(trainer, forKey: "trainer")
                        self.defaultValues.set(first, forKey: "firstname")
                        self.defaultValues.set(surname, forKey: "surname")
                        self.defaultValues.set(email, forKey: "email")
                        self.defaultValues.set(dob, forKey: "dob")
                        
                        self.defaultValues.set(weight, forKey: "weight")
                        self.defaultValues.set(height, forKey: "height")
                        
                        //switching the screen
                        
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let tabBarController = storyboard.instantiateViewController(withIdentifier: "TabBarController") as! UITabBarController
                        let appDelegate = UIApplication.shared.delegate as! AppDelegate
                        appDelegate.window?.rootViewController = tabBarController

                    }else{
                        //error message in case of invalid credential
                        self.displayMessage(userMessage: (jsonData.value(forKey: "message") as! String?)!)
                    }
                }
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
    
    @IBAction func registerButtonTapped(_ sender: Any) {
        print ("register button tapped")
        
        let SignUpViewController = self.storyboard?.instantiateViewController(withIdentifier:
            "SignUpViewController") as! SignUpViewController
        
        self.present(SignUpViewController, animated: true)
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
