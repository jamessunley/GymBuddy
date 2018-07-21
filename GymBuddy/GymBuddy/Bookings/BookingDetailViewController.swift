//
//  BookingDetailViewController.swift
//  GymBuddy
//
//  Created by James Sunley on 26/02/2018.
//  Copyright © 2018 James Sunley. All rights reserved.
//

import UIKit
import Foundation
import Alamofire

class BookingDetailViewController: UIViewController {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var secondLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var headingLabel: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    var selectedBooking : BookingModel?
    
    override func viewDidLoad() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        if (formatter.date(from: (selectedBooking?.date_time)!)! < Date()){
            cancelButton.isHidden = true
        }
        
        headingLabel.text = "Your Booking is at: "
        dateLabel.text = selectedBooking!.date_time!
        firstLabel.text = "and is with:"
        secondLabel.text = selectedBooking!.trainer_first_name! + " " + selectedBooking!.trainer_surname!
        priceLabel.text = "Total cost: £" + selectedBooking!.trainer_price!

        print(selectedBooking!.booking_id!)
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func CancelButtonTapped(_ sender: Any) {
        
        // create the alert
        let alert = UIAlertController(title: "Cancel Booking", message: "Are you sure you want to cancel this booking?", preferredStyle: UIAlertControllerStyle.alert)
        
        // add the actions (buttons)
        
        alert.addAction(UIAlertAction(title: "Keep Booking", style: UIAlertActionStyle.cancel, handler: nil))

        //handle button taps
        alert.addAction(UIAlertAction(title: "Cancel the booking!", style: UIAlertActionStyle.destructive, handler: { action in
            
            let ID = Int(self.selectedBooking!.booking_id!)
            let parameters: Parameters=[
                "id":ID!
            ]
            Alamofire.request("http://94.12.191.140/api_test/v1/bookingdel.php", method: .post, parameters: parameters, encoding: URLEncoding()).responseJSON
                {
                    response in
                    //printing response
                    print(response)
            }
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
            self.navigationController?.popViewController(animated: true)
        }))
        // show the alert
        self.present(alert, animated: true, completion: nil)

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
