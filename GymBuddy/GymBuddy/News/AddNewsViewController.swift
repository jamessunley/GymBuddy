//
//  AddNewsViewController.swift
//  GymBuddy
//
//  Created by James Sunley on 26/02/2018.
//  Copyright © 2018 James Sunley. All rights reserved.
//

import UIKit
import Alamofire

class AddNewsViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var overviewTextView: UITextView!
    @IBOutlet weak var bodyTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.titleTextField.delegate = self;
        self.overviewTextView.delegate = self;
        self.bodyTextView.delegate = self;
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText     text: String) -> Bool {
        if text == "\n"
        {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    @IBAction func addNewsButtonTapped(_ sender: Any) {
        let defaultValues = UserDefaults.standard
        let parameters: Parameters=[
            "title":titleTextField.text!,
            "overview":overviewTextView.text!,
            "content":bodyTextView.text!,
            "username":defaultValues.string(forKey: "username")!]
        Alamofire.request("http://94.12.191.140/api_test/v1/addNews.php", method: .post, parameters: parameters, encoding: URLEncoding()).responseJSON
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
                            self.dismiss(animated: true, completion: nil)
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
                        }
                    }
                    alertController.addAction(OKAction)
                }
        }
    }
    
    @IBAction func returnButtonTapped(_ sender: UIBarButtonItem) {
        self.dismiss(animated: false, completion: nil)
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
