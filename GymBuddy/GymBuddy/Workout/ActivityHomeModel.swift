//
//  ActivityHomeModel.swift
//  GymBuddy
//
//  Created by James Sunley on 15/03/2018.
//  Copyright © 2018 James Sunley. All rights reserved.
//

import Foundation
import Alamofire

protocol ActivityHomeModelProtocol: class {
    func itemsDownloaded(items: NSArray)
}

class ActivityHomeModel: NSObject, URLSessionDataDelegate {
    
    //properties
    
    weak var delegate: ActivityHomeModelProtocol!
    var data = Data()
    
    func downloadItems() {
        let defaultValues = UserDefaults.standard
        let parameters: Parameters=[
            "id": defaultValues.integer(forKey: "sessionid"),
            ]
        Alamofire.request("http://94.12.191.140/api_test/v1/activity.php", method: .post, parameters: parameters).responseJSON
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
                        let user = jsonData.value(forKey: "activity") as! NSArray
                        var jsonElement = NSDictionary()
                        let activityall = NSMutableArray()
                        
                        for i in 0 ..< user.count
                        {
                            jsonElement = user[i] as! NSDictionary
                            
                            let activity = ActivityModel()
                            
                            //the following ensures none of the JsonElement values are nil through optional binding
                            if let activity_name = jsonElement["activity_name"] as? String,
                                let type = jsonElement["type"] as? String,
                                let activity_id = jsonElement["activity_id"] as? Int,
                                let completed = jsonElement["completed"] as? Int
                            {
                                let id = String(activity_id)
                                let com = String(completed)
                                activity.activity_id = id
                                activity.activity_name = activity_name
                                activity.type = type
                                activity.completed = com
                            }
                            
                            activityall.add(activity)
                            print(activityall)
                            
                        }
                        
                        DispatchQueue.main.async(execute: { () -> Void in
                            
                            self.delegate.itemsDownloaded(items: activityall)
                            
                        })
                    }
                }
        }
    }

}
