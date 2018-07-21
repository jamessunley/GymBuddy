//
//  AvailabilityViewController.swift
//  GymBuddy
//
//  Created by James Sunley on 26/03/2018.
//  Copyright © 2018 James Sunley. All rights reserved.
//

import UIKit
import Alamofire

class AvailabilityViewController: UIViewController {

    @IBOutlet weak var startDatePicker: UIDatePicker!
    @IBOutlet weak var endDatePicker: UIDatePicker!
    override func viewDidLoad() {
        super.viewDidLoad()
        //sets minimum and maximum on date picker
        let currentDate: Date = Date()
        var calendar: Calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        calendar.timeZone = TimeZone(identifier: "UTC")!
        var components: DateComponents = DateComponents()
        components.calendar = calendar
        
        components.hour = 1
        let minDate: Date = calendar.date(byAdding: components, to: currentDate)!
        components.month = 4
        let maxDate: Date = calendar.date(byAdding: components, to: currentDate)!
        
        startDatePicker.minimumDate = minDate
        startDatePicker.maximumDate = maxDate
        endDatePicker.maximumDate = maxDate
        endDatePicker.minimumDate = minDate
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

    @IBAction func submitButtonTapped(_ sender: UIButton) {
        
        let formatter = DateFormatter()
        
        formatter.calendar = startDatePicker.calendar
        formatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss'"
        let start_date = formatter.string(from: startDatePicker.date)
        let end_date = formatter.string(from: endDatePicker.date)

        print(start_date)
        print(end_date)
        
        let defaultValues = UserDefaults.standard
        
        //send parameters
        let parameters: Parameters=[
            "start":start_date,
            "end":end_date,
            "user_id": defaultValues.integer(forKey: "userid")]
        
        Alamofire.request("http://94.12.191.140/api_test/v1/availability.php", method: .post, parameters: parameters, encoding: URLEncoding()).responseJSON
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
                            self.dismiss(animated: false, completion: nil)
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
                        }
                    }
                    alertController.addAction(OKAction)
                }
        }
    }
}
