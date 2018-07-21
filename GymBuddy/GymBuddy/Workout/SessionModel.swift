//
//  SessionModel.swift
//  GymBuddy
//
//  Created by James Sunley on 14/03/2018.
//  Copyright © 2018 James Sunley. All rights reserved.
//

import Foundation

class SessionModel: NSObject {
    
    //properties
    
    var session_id: String?
    var planned_date: String?
    
    //empty constructor
    
    override init()
    {
        
    }
    
    init(session_id: String, planned_date: String){
        
        self.session_id = session_id
        self.planned_date = planned_date
        
    }
    
    //prints object's current state
    
    override var description: String {
        return "session_id: \(String(describing: session_id)), planned_date: \(String(describing: planned_date))"
        
    }

}
