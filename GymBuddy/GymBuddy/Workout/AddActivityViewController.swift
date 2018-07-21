//
//  AddActivityViewController.swift
//  GymBuddy
//
//  Created by James Sunley on 16/03/2018.
//  Copyright © 2018 James Sunley. All rights reserved.
//

import UIKit
import Alamofire

class AddActivityViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var addActivityNew: UIButton!
    @IBOutlet weak var addActivity: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var activityTextField: UITextField!
    let defaultValues = UserDefaults.standard
    var type = "C"
    @IBAction func typeSwitch(_ sender: UISwitch) {
        if(sender.isOn){
            type = "C"
            titleLabel.text = "Cardio Exercise"
        }else {
            type = "W"
            titleLabel.text = "Strength Exercise"
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        if (defaultValues.string(forKey: "sessionid") == "9999"){
            self.addActivity.isHidden = true
            self.addActivityNew.isHidden = false
            self.addActivity.isEnabled = false
            self.addActivityNew.isEnabled = true
        }else{
            self.addActivity.isHidden = false
            self.addActivityNew.isHidden = true
            self.addActivity.isEnabled = true
            self.addActivityNew.isEnabled = false
        }
        self.activityTextField.delegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addActivity(_ sender: Any) {
        let parameters: Parameters=[
            "name":activityTextField.text!,
            "type":type,
            "session_id":defaultValues.string(forKey: "sessionid")!,
            "user_id":defaultValues.string(forKey: "userid")!]
        Alamofire.request("http://94.12.191.140/api_test/v1/addActivity.php", method: .post, parameters: parameters, encoding: URLEncoding()).responseJSON
            {
                response in
                //printing response
                print(response)
                //getting the json value from the server
                if let result = response.result.value {
                    
                    //converting it as NSDictionary
                    let jsonData = result as! NSDictionary
                    
                    //displaying the message to user
                    let alertController = UIAlertController(title: "Alert", message: (jsonData.value(forKey: "message")as! String), preferredStyle: .alert)
                    self.present(alertController, animated: true, completion: nil)
                    let OKAction = UIAlertAction(title: "OK", style: .default)
                    { (action: UIAlertAction!)in
                        print ("OK tapped")
                        DispatchQueue.main.async {
                            if(self.defaultValues.string(forKey: "sessionid") == "9999"){
                            }else{
                                self.navigationController?.popViewController(animated: true)
                                self.dismiss(animated: false, completion: nil)
                            }
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
                        }
                    }
                    alertController.addAction(OKAction)
                }
        }
    }
    @IBAction func addActivityButtonTapped(_ sender: UIButton) {
        
        let parameters: Parameters=[
            "name":activityTextField.text!,
            "type":type,
            "session_id":defaultValues.string(forKey: "sessionid")!,
            "user_id":defaultValues.string(forKey: "userid")!]
        Alamofire.request("http://94.12.191.140/api_test/v1/addActivity.php", method: .post, parameters: parameters, encoding: URLEncoding()).responseJSON
            {
                response in
                //printing response
                print(response)
                //getting the json value from the server
                if let result = response.result.value {
                    
                    //converting it as NSDictionary
                    let jsonData = result as! NSDictionary
                    
                    //displaying the message to user
                    let alertController = UIAlertController(title: "Alert", message: (jsonData.value(forKey: "message")as! String), preferredStyle: .alert)
                    self.present(alertController, animated: true, completion: nil)
                    let OKAction = UIAlertAction(title: "OK", style: .default)
                    { (action: UIAlertAction!)in
                        print ("OK tapped")
                        DispatchQueue.main.async {
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
                        }
                    }
                    alertController.addAction(OKAction)
                }
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
