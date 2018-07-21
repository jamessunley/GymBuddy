//
//  MapViewController.swift
//  GymBuddy
//
//  Created by James Sunley on 26/03/2018.
//  Copyright © 2018 James Sunley. All rights reserved.
//

import UIKit
import MapKit
class MapViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    override func viewDidLoad() {
        
        let distanceSpan:CLLocationDegrees = 1000
        let TheGYMLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(54.85418204892787, -1.832929726155271)
        let BodyBlitzLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(54.85425770674934, -1.8324952082948585)
        let JGLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(54.854225281986075, -1.832680280716886)
        let BigAlLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(54.85900438559694, -1.8100672960281372)
        let LifeStyleFitnessLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(54.85847329631644, -1.8299531936645508)
        let SpartanLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(54.86373756425207, -1.8216866254806519)
        
        mapView.setRegion(MKCoordinateRegionMakeWithDistance(TheGYMLocation, distanceSpan, distanceSpan), animated: true)
        
        let theGYMClassPin = GymAnnotation(title: "The GYM Consett", subtitle: "A small independent gym", coordinate: TheGYMLocation)
        let bodyBlitzClassPin = GymAnnotation(title: "Body Blitz", subtitle: "A class focused womens gym", coordinate: BodyBlitzLocation)
        let jGClassPin = GymAnnotation(title: "JG", subtitle: "A small class based gym", coordinate: JGLocation)
        let bigAlClassPin = GymAnnotation(title: "Big Al's, Cutz 'n' Curves", subtitle: "A powerlifting and weightlifting specific gym", coordinate: BigAlLocation)
        let lifeStyleFitnessPin = GymAnnotation(title: "Life Style Fitness", subtitle: "A chain of Gyms within Consett Leisure Center", coordinate: LifeStyleFitnessLocation)
        let spartanPin = GymAnnotation(title: "Spartan Performance", subtitle: "Performance gym, the lieks of Newcastle Falcons have trainer here in the past", coordinate: SpartanLocation)
        
        mapView.addAnnotation(theGYMClassPin)
        mapView.addAnnotation(bodyBlitzClassPin)
        mapView.addAnnotation(jGClassPin)
        mapView.addAnnotation(bigAlClassPin)
        mapView.addAnnotation(lifeStyleFitnessPin)
        mapView.addAnnotation(spartanPin)

        mapView.showsUserLocation = true
        mapView.showsPointsOfInterest = true
        mapView.showsTraffic = true
        mapView.showsBuildings = true
        
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled(){
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func SignOutButtonTapped(_ sender: UIBarButtonItem) {
        //removing values from default
        UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
        UserDefaults.standard.synchronize()
        
        //switching to login screen
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let LogInViewController = storyboard.instantiateViewController(withIdentifier: "LogInViewController") as! LogInViewController
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = LogInViewController
    }
}
