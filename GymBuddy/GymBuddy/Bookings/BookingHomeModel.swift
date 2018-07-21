//
//  BookingHomeModel.swift
//  GymBuddy
//
//  Created by James Sunley on 07/03/2018.
//  Copyright © 2018 James Sunley. All rights reserved.
//
import Foundation
import Alamofire

protocol BookingHomeModelProtocol: class {
    func itemsDownloaded(items: NSArray)
}

class BookingHomeModel: NSObject, URLSessionDataDelegate{
    
    //properties
    
    weak var delegate: BookingHomeModelProtocol!
    var data = Data()

    func downloadItems() {
        let defaultValues = UserDefaults.standard
        print(defaultValues.integer(forKey: "userid"))
        let parameters: Parameters=[
            "id":defaultValues.integer(forKey: "userid"),
            "trainer":defaultValues.integer(forKey: "trainer")
        ]
        Alamofire.request("http://94.12.191.140/api_test/v1/booking.php", method: .post, parameters: parameters).responseJSON
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
                        let user = jsonData.value(forKey: "booking") as! NSArray
                        var jsonElement = NSDictionary()
                        let bookingall = NSMutableArray()
                        
                        for i in 0 ..< user.count
                        {
                            
                            jsonElement = user[i] as! NSDictionary
                            
                            let booking = BookingModel()
       
                            //the following ensures none of the JsonElement values are nil through optional binding
                            if let booking_id = jsonElement["booking_id"] as? Int,
                                let date_time = jsonElement["date_time"] as? String,
                                let trainer_first_name = jsonElement["trainer_first_name"] as? String,
                                let trainer_surname = jsonElement["trainer_surname"] as? String,
                                let trainer_price = jsonElement["trainer_price"] as? Int
                                
                            {
                                let id = String(booking_id)
                                let price = String(trainer_price)
                                booking.booking_id = id
                                booking.date_time = date_time
                                booking.trainer_first_name = trainer_first_name
                                booking.trainer_surname = trainer_surname
                                booking.trainer_price = price
                            }
                            
                            bookingall.add(booking)
                            print(bookingall)
                            
                        }
                        
                        DispatchQueue.main.async(execute: { () -> Void in
                            
                            self.delegate.itemsDownloaded(items: bookingall)
                            
                        })
                    }
                }
        }
    }
}
