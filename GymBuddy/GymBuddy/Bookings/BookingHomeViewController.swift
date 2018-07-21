//
//  BookingHomeViewController.swift
//  GymBuddy
//
//  Created by James Sunley on 27/02/2018.
//  Copyright © 2018 James Sunley. All rights reserved.
//

import UIKit
import Alamofire

struct Trainer: Decodable {
    let username: String
}
class BookingHomeViewController: UIViewController,UIPickerViewDataSource,UIPickerViewDelegate {

    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var bookingTime: UIDatePicker!
    @IBOutlet weak var trainer: UIPickerView!
    var trainers = [Trainer]()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        trainer.delegate = self
        trainer.dataSource = self
        
        // identifies if user is a trainer to populate spinner with either trainers or clients
        let defaultValues = UserDefaults.standard
        defaultValues.integer(forKey: "trainer")
        var url = URL(string: "")
        if (defaultValues.integer(forKey: "trainer") == 0){
            url = URL(string: "http://94.12.191.140/api_test/v1/trainer.php")
            typeLabel.text = "Select Trainer"
        }else if (defaultValues.integer(forKey: "trainer") == 1){
            url = URL(string: "http://94.12.191.140/api_test/v1/client.php")
            typeLabel.text = "Select Client"
        }
        
        URLSession.shared.dataTask(with: url!){(data, response, error) in
            if error == nil {
                do{
                    self.trainers = try JSONDecoder().decode([Trainer].self, from: data!)
                }catch{
                    print("Parse Error")
                }
                
                DispatchQueue.main.async {
                    self.trainer.reloadComponent(0)
                }
            }
        }.resume()
        
        //sets minimum and maximum on date picker
        let currentDate: Date = Date()
        var calendar: Calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        calendar.timeZone = TimeZone(identifier: "UTC")!
        var components: DateComponents = DateComponents()
        components.calendar = calendar
        
        components.hour = 1
        let minDate: Date = calendar.date(byAdding: components, to: currentDate)!
        components.month = 3
        let maxDate: Date = calendar.date(byAdding: components, to: currentDate)!
        
        bookingTime.minimumDate = minDate
        bookingTime.maximumDate = maxDate

        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // The number of columns of data
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // The number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return trainers.count + 1
    }
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return row == 0 ? "" : trainers[row - 1].username
    }
    var selectedUsername:String = "username"
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent  component: Int) {
        selectedUsername = (trainers[row - 1].username as String?)!
    }

    @IBAction func AvailabilityButtonTapped(_ sender: Any) {
        let formatter = DateFormatter()
        let formatter1 = DateFormatter()
        formatter1.calendar = bookingTime.calendar
        formatter1.dateFormat = "HH':'mm':'ss"
        formatter.dateFormat = "HH':'mm':'ss"
        let time = formatter.string(from: bookingTime.date)
        if (formatter.date(from: "19-00-00")!>formatter1.date(from: time)! && formatter.date(from: "06-00-00")!<formatter1.date(from: time)!){
            print ("works")
            let formatter2 = DateFormatter()

            formatter2.calendar = bookingTime.calendar
            formatter2.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss"
            
            let date = formatter2.string(from: bookingTime.date)
            print(date)
            
            print(selectedUsername)
            //send parameters
            let defaultValues = UserDefaults.standard
            let parameters: Parameters=[
                "username":selectedUsername,
                "date_time":date,
                "id":defaultValues.integer(forKey: "userid")]
            
            if (selectedUsername == "username"){
                let alertController = UIAlertController(title: "Alert", message: "Please select a client or trainer to book with.", preferredStyle: .alert)
                self.present(alertController, animated: true, completion: nil)
                let OKAction = UIAlertAction(title: "OK", style: .default)
                { (action: UIAlertAction!)in
                    print ("OK tapped")
                    DispatchQueue.main.async {
                        self.dismiss(animated: true, completion: nil)
                    }
                }
                alertController.addAction(OKAction)
                
            }else{
                Alamofire.request("http://94.12.191.140/api_test/v1/bookingverify.php", method: .post, parameters: parameters, encoding: URLEncoding()).responseJSON
                    {
                        response in
                        //printing response
                        print(response)
                        //getting the json value from the server
                        if let result = response.result.value {
                            
                            //converting it as NSDictionary
                            let jsonData = result as! NSDictionary
                            
                            if (jsonData.value(forKey: "error")as! Bool == true)
                            {
                                let alertController = UIAlertController(title: "Alert", message: (jsonData.value(forKey: "message")as! String), preferredStyle: .alert)
                                self.present(alertController, animated: true, completion: nil)
                                let OKAction = UIAlertAction(title: "OK", style: .default)
                                { (action: UIAlertAction!)in
                                    print ("OK tapped")
                                    DispatchQueue.main.async {
                                        self.dismiss(animated: true, completion: nil)
                                    }
                                }
                                alertController.addAction(OKAction)
                            }else if(jsonData.value(forKey: "error")as! Bool == false)
                            {
                                let alertController = UIAlertController(title: "Alert", message: (jsonData.value(forKey: "message")as! String), preferredStyle: .alert)
                                self.present(alertController, animated: true, completion: nil)
                                let OKAction = UIAlertAction(title: "OK", style: .default)
                                { (action: UIAlertAction!)in
                                    print ("OK tapped")
                                    DispatchQueue.main.async {
                                        let defaultValues = UserDefaults.standard
                                        let parametersAdd: Parameters=[
                                            "username":self.selectedUsername,
                                            "date_time":date,
                                            "id":defaultValues.integer(forKey: "userid")]
                                        
                                        Alamofire.request("http://94.12.191.140/api_test/v1/bookingadd.php", method: .post, parameters: parametersAdd, encoding: URLEncoding()).responseJSON
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
                                                        }
                                                    }
                                                    alertController.addAction(OKAction)
                                                }
                                        }
                                    }
                                }
                                alertController.addAction(OKAction)
                                let CancelAction = UIAlertAction(title: "Cancel", style: .default)
                                { (action: UIAlertAction!)in
                                    print ("Cancel tapped")
                                    DispatchQueue.main.async {
                                        self.dismiss(animated: true, completion: nil)
                                    }
                                }
                                alertController.addAction(CancelAction)
                            }
                            //displaying the message to user
                            //self.displayMessage(userMessage: (jsonData.value(forKey: "message") as! String?)!)
                            
                        }
                }
                
            }
            
        }else {
            let alertController = UIAlertController(title: "Alert", message: "Please select a time between 06:00 and 19:00", preferredStyle: .alert)
            self.present(alertController, animated: true, completion: nil)
            let OKAction = UIAlertAction(title: "OK", style: .default)
            { (action: UIAlertAction!)in
                print ("OK tapped")
                DispatchQueue.main.async {
                    self.dismiss(animated: true, completion: nil)
                }
            }
            alertController.addAction(OKAction)
        }
        }
        
    @IBAction func signOutButtonTapped(_ sender: UIBarButtonItem) {
        //removing values from default
        UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
        UserDefaults.standard.synchronize()
        
        //switching to login screen
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let LogInViewController = storyboard.instantiateViewController(withIdentifier: "LogInViewController") as! LogInViewController
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = LogInViewController
    }
    @IBAction func CurrentBookingsButonTapped(_ sender: Any) {
        performSegue(withIdentifier: "Bookings", sender: self)
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
