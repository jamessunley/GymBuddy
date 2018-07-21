//
//  SessionHomeModel.swift
//  GymBuddy
//
//  Created by James Sunley on 14/03/2018.
//  Copyright © 2018 James Sunley. All rights reserved.
//

import Foundation
import Alamofire

protocol SessionHomeModelProtocol: class {
    func itemsDownloaded(items: NSArray)
}

class SessionHomeModel: NSObject, URLSessionDataDelegate {
    //properties
    
    weak var delegate: SessionHomeModelProtocol!
    var data = Data()
    
    func downloadItems() {
        let defaultValues = UserDefaults.standard
        let parameters: Parameters=[
            "id":defaultValues.integer(forKey: "userid"),
        ]
        Alamofire.request("http://94.12.191.140/api_test/v1/session.php", method: .post, parameters: parameters).responseJSON
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
                        let user = jsonData.value(forKey: "session") as! NSArray
                        var jsonElement = NSDictionary()
                        let sessionall = NSMutableArray()
                        
                        let firstSession = SessionModel()
                        firstSession.session_id = "9999"
                        firstSession.planned_date = "Add Session"
                        
                        sessionall.add(firstSession)
                        
                        for i in 0 ..< user.count
                        {
                            jsonElement = user[i] as! NSDictionary
                            
                            let session = SessionModel()
                            
                            //the following ensures none of the JsonElement values are nil through optional binding
                            if let session_id = jsonElement["session_id"] as? Int,
                                let planned_date = jsonElement["planned_date"] as? String
                                
                            {
                                let id = String(session_id)
                                session.session_id = id
                                session.planned_date = planned_date
                                
                            }
                            
                            sessionall.add(session)
                            print(sessionall)
                            
                        }
                        
                        DispatchQueue.main.async(execute: { () -> Void in
                            
                            self.delegate.itemsDownloaded(items: sessionall)
                            
                        })
                    }
                }
        }
    }

}
