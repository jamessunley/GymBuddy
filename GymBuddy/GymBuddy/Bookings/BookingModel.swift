//
//  BookingModel.swift
//  GymBuddy
//
//  Created by James Sunley on 07/03/2018.
//  Copyright © 2018 James Sunley. All rights reserved.
//

import Foundation

class BookingModel: NSObject {
    
    //properties
    
    var booking_id: String?
    var date_time: String?
    var trainer_first_name: String?
    var trainer_surname: String?
    var trainer_price: String?
    
    //empty constructor
    
    override init()
    {
        
    }
    
    init(booking_id: String, date_time: String, trainer_first_name: String, trainer_surname: String, trainer_price:String) {
        
        self.booking_id = booking_id
        self.date_time = date_time
        self.trainer_first_name = trainer_first_name
        self.trainer_surname = trainer_surname
        self.trainer_price = trainer_price
        
    }
    
    //prints object's current state
    
    override var description: String {
        return "booking_id: \(String(describing: booking_id)), date_time: \(String(describing: date_time)), trainer_first_name: \(String(describing: trainer_first_name)), trainer_surname: \(String(describing: trainer_surname)), trainer_price: \(String(describing: trainer_price))"
        
    }
    
}
