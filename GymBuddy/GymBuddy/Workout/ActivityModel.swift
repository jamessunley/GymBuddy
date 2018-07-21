//
//  ActivityModel.swift
//  GymBuddy
//
//  Created by James Sunley on 15/03/2018.
//  Copyright © 2018 James Sunley. All rights reserved.
//

import Foundation

class ActivityModel: NSObject {
    
    //properties
    var activity_id: String?
    var activity_name: String?
    var type: String?
    var completed: String?
    
    //empty constructor
    
    override init()
    {
        
    }
    
    init(activity_id:String, activity_name: String, type: String, completed: String){
        self.activity_id = activity_id
        self.activity_name = activity_name
        self.type = type
        self.completed = completed
        
    }
    
    //prints object's current state
    
    override var description: String {
        return "activity_id: \(String(describing: activity_id)), activity_name: \(String(describing: activity_name)), type: \(String(describing: type)), completed: \(String(describing: completed))"
        
    }

}
