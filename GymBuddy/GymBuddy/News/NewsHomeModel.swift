//
//  NewsHomeModel.swift
//  GymBuddy
//
//  Created by James Sunley on 22/02/2018.
//  Copyright © 2018 James Sunley. All rights reserved.
//

import Foundation

protocol NewsHomeModelProtocol: class {
    func itemsDownloaded(items: NSArray)
}

class NewsHomeModel: NSObject, URLSessionDataDelegate{
    
    //properties
    
    weak var delegate: NewsHomeModelProtocol!
    
    var data = Data()
    
    let urlPath: String = "http://94.12.191.140/api_test/v1/news.php"
    
    func downloadItems() {
        
        let url: URL = URL(string: urlPath)!
        let defaultSession = Foundation.URLSession(configuration: URLSessionConfiguration.default)
        
        let task = defaultSession.dataTask(with: url) { (data, response, error) in
            
            if error != nil {
                print("Failed to download data")
            }else {
                print("Data downloaded")
                self.parseJSON(data!)

            }
            
        }
        
        task.resume()
    }
    
    func parseJSON(_ data:Data) {
        
        var jsonResult = NSArray()
        
        do{
            jsonResult = try JSONSerialization.jsonObject(with: data, options:JSONSerialization.ReadingOptions.allowFragments) as! NSArray
            
        } catch let error as NSError {
            print(error)
            
        }
        
        var jsonElement = NSDictionary()
        let newsall = NSMutableArray()
        
        for i in 0 ..< jsonResult.count
        {
            
            jsonElement = jsonResult[i] as! NSDictionary
            
            let news = NewsModel()
            
            //the following ensures none of the JsonElement values are nil through optional binding
            if let title = jsonElement["title"] as? String,
                let content = jsonElement["content"] as? String,
                let overview = jsonElement["overview"] as? String,
                let trainer = jsonElement["trainer_username"] as? String
            {
                
                news.title = title
                news.content = content
                news.overview = overview
                news.trainer = trainer
                
            }
            
            newsall.add(news)
            print(newsall)
            
        }
        
        DispatchQueue.main.async(execute: { () -> Void in
            
            self.delegate.itemsDownloaded(items: newsall)
            
        })
    }


}
