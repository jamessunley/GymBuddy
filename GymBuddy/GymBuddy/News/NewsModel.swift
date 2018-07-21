//
//  NewsModel.swift
//  GymBuddy
//
//  Created by James Sunley on 22/02/2018.
//  Copyright © 2018 James Sunley. All rights reserved.
//

import Foundation

class NewsModel: NSObject {
    
    //properties
    
    var title: String?
    var content: String?
    var overview: String?
    var trainer: String?
    
    
    //empty constructor
    
    override init()
    {
        
    }
    
    //construct with @title, @content, @overview, and @trainer parameters
    
    init(title: String, content: String, overview: String, trainer: String) {
        
        self.title = title
        self.content = content
        self.overview = overview
        self.trainer = trainer
        
    }
    
    
    //prints object's current state
    
    override var description: String {
        return "title: \(String(describing: title)), content: \(String(describing: content)), overview: \(String(describing: overview)), trainer_username: \(String(describing: trainer))"
        
    }

}
