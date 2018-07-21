//
//  GymAnnotation.swift
//  GymBuddy
//
//  Created by James Sunley on 26/03/2018.
//  Copyright © 2018 James Sunley. All rights reserved.
//

import MapKit

class GymAnnotation: NSObject, MKAnnotation {
    var title: String?
    var subtitle: String?
    var coordinate: CLLocationCoordinate2D
    
    init(title:String, subtitle:String, coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
    }
}
