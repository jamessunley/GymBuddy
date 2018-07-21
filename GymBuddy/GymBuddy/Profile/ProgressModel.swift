//
//  ProgressModel.swift
//  GymBuddy
//
//  Created by James Sunley on 22/03/2018.
//  Copyright © 2018 James Sunley. All rights reserved.
//

import Foundation

class ProgressModel: NSObject {
    
    //properties
    var planned_date: String?
    var repsORdistance: String?
    var weightORtime: String?
    var setsORlaps: String?
    
    //empty constructor
    
    override init()
    {
        
    }
    
    init(planned_date:String, repsORdistance: String, weightORtime: String, setsORlaps: String){
        self.planned_date = planned_date
        self.repsORdistance = repsORdistance
        self.weightORtime = weightORtime
        self.setsORlaps = setsORlaps
        
    }
    
    //prints object's current state
    
    override var description: String {
        return "planned_date: \(String(describing: planned_date)), repsORdistance: \(String(describing: repsORdistance)), weightORtime: \(String(describing: weightORtime)), setsORlaps: \(String(describing: setsORlaps))"
        
    }

}
