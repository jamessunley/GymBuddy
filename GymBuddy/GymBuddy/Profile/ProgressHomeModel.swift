//
//  ProgressHomeModel.swift
//  GymBuddy
//
//  Created by James Sunley on 22/03/2018.
//  Copyright © 2018 James Sunley. All rights reserved.
//

import UIKit
import Alamofire

protocol ProgressHomeModelProtocol: class {
    func itemsDownloaded(items: NSArray)
}
class ProgressHomeModel: NSObject, URLSessionDataDelegate {
    
    //properties
    
    weak var delegate: ProgressHomeModelProtocol!
    var data = Data()
    
    func downloadItems() {
        let defaultValues = UserDefaults.standard
        let parameters: Parameters=[
            "activity_id": defaultValues.integer(forKey: "activityid"),
            "user_id": defaultValues.integer(forKey: "userid"),
            "type": defaultValues.string(forKey: "type")!
            ]
        Alamofire.request("http://94.12.191.140/api_test/v1/progress.php", method: .post, parameters: parameters).responseJSON
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
                        let user = jsonData.value(forKey: "progress") as! NSArray
                        var jsonElement = NSDictionary()
                        let activityall = NSMutableArray()
                        
                        let defaultValues = UserDefaults.standard
                        if (defaultValues.string(forKey: "type") == "W"){
                            for i in 0 ..< user.count
                            {
                                jsonElement = user[i] as! NSDictionary
                                
                                let activity = ProgressModel()
                                
                                //the following ensures none of the JsonElement values are nil through optional binding
                                if let planned_date = jsonElement["planned_date"] as? String,
                                    let Reps = jsonElement["Reps"] as? Double,
                                    let weight = jsonElement["weight"] as? Double,
                                    let sets = jsonElement["sets"] as? Double
                                {
                                    let reps = String (Reps)
                                    let wei = String (weight)
                                    let set = String (sets)
                                    activity.planned_date = planned_date
                                    activity.repsORdistance = reps
                                    activity.weightORtime = wei
                                    activity.setsORlaps = set
                                }
                                
                                activityall.add(activity)
                                print(activityall)
                                
                            }
                        }else if (defaultValues.string(forKey: "type") == "C"){
                            for i in 0 ..< user.count
                            {
                                jsonElement = user[i] as! NSDictionary
                                
                                let activity = ProgressModel()
                                
                                //the following ensures none of the JsonElement values are nil through optional binding
                                if let planned_date = jsonElement["planned_date"] as? String,
                                    let Reps = jsonElement["distance"] as? Double,
                                    let weight = jsonElement["time"] as? Double,
                                    let sets = jsonElement["laps"] as? Double
                                {
                                    let reps = String (Reps)
                                    let wei = String (weight)
                                    let set = String (sets)
                                    activity.planned_date = planned_date
                                    activity.repsORdistance = reps
                                    activity.weightORtime = wei
                                    activity.setsORlaps = set
                                }
                                
                                activityall.add(activity)
                                print(activityall)
                                
                            }
                        }
                        

                        
                        DispatchQueue.main.async(execute: { () -> Void in
                            
                            self.delegate.itemsDownloaded(items: activityall)
                            
                        })
                    }
                }
        }
    }

}
