//
//  WorkoutWeightsViewController.swift
//  GymBuddy
//
//  Created by James Sunley on 26/02/2018.
//  Copyright © 2018 James Sunley. All rights reserved.
//

import UIKit
import Alamofire

class WorkoutWeightsViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var repLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var setsLabel: UILabel!
    @IBOutlet weak var repsTextField: UITextField!
    @IBOutlet weak var weightTextField: UITextField!
    @IBOutlet weak var setsTextField: UITextField!
    var selectedActivity : ActivityModel?
    override func viewDidLoad() {
        titleLabel.text = selectedActivity!.activity_name
        if(selectedActivity?.type == "W"){
            repLabel.text = "Enter the number of reps: "
            weightLabel.text = "Enter the weight used(KGs): "
            setsLabel.text = "Enter the number of sets completed:"
            repsTextField.placeholder = "Enter the number of reps: "
            weightTextField.placeholder = "Enter the weight used(KGs): "
            setsTextField.placeholder = "Enter the number of sets completed:"
        }else if(selectedActivity?.type == "C"){
            repLabel.text = "Enter the distance completed: "
            weightLabel.text = "Enter the time(minutes): "
            setsLabel.text = "Enter the number of laps completed:"
            repsTextField.placeholder = "Enter the distance completed: "
            weightTextField.placeholder = "Enter the time(minutes): "
            setsTextField.placeholder = "Enter the number of laps completed:"
        }
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func completeButtonTapped(_ sender: UIButton) {
        let defaultValues = UserDefaults.standard
        let reps = Double(repsTextField.text!)
        let weight = Double(weightTextField.text!)
        let sets = Double(setsTextField.text!)
        let parameters: Parameters=[
            "activity_id":selectedActivity?.activity_id as! String,
            "session_id":defaultValues.string(forKey: "sessionid")!,
            "repsORdistance":reps!,
            "weightORtime":weight!,
            "setsORlaps":sets!,
            "type":selectedActivity?.type as! String]
        Alamofire.request("http://94.12.191.140/api_test/v1/completeActivity.php", method: .post, parameters: parameters, encoding: URLEncoding()).responseJSON
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
                            self.navigationController?.popViewController(animated: true)
                            self.dismiss(animated: false, completion: nil)

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
