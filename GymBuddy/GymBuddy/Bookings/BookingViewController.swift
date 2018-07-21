//
//  BookingViewController.swift
//  GymBuddy
//
//  Created by James Sunley on 26/02/2018.
//  Copyright © 2018 James Sunley. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON


class BookingViewController: UIViewController, UITableViewDataSource, UITableViewDelegate,BookingHomeModelProtocol{
    
//    var arrRes = [[String:AnyObject]]() //Array of dictionary

    var feedItems: NSArray = NSArray()
    var selectedBooking : BookingModel = BookingModel()
    @IBOutlet weak var listTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.listTableView.delegate = self
        self.listTableView.dataSource = self
        
        let bookingHomeModel = BookingHomeModel()
        bookingHomeModel.delegate = self
        bookingHomeModel.downloadItems()
        NotificationCenter.default.addObserver(self, selector: #selector(loadList), name: NSNotification.Name(rawValue: "load"), object: nil)

        // Do any additional setup after loading the view.
    }
    
    @objc func loadList(){
        let bookingHomeModel = BookingHomeModel()
        bookingHomeModel.delegate = self
        bookingHomeModel.downloadItems()
        self.listTableView.reloadData()
    }
        
    func itemsDownloaded(items: NSArray) {
        
        feedItems = items
        self.listTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feedItems.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Retrieve cell
        let cellIdentifier: String = "BasicCell"
        let myCell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)!
        // Get the news to be shown
        let booking: BookingModel = feedItems[indexPath.row] as! BookingModel
        // Get references to labels of cell
        myCell.textLabel!.text = booking.date_time
        myCell.detailTextLabel?.text = booking.trainer_first_name! + " " + booking.trainer_surname!
        let formatter = DateFormatter()
        
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = formatter.date(from: booking.date_time!)
        print (date as Any)
        if(formatter.date(from: (booking.date_time)!)! < Date()){
            myCell.detailTextLabel?.textColor = UIColor.red
            myCell.textLabel?.textColor = UIColor.red
        }
        
        return myCell
    }
    
    func tableView(_ listTableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Set selected news to var
        selectedBooking = feedItems[indexPath.row] as! BookingModel
        // Manually call segue to detail view controller
        self.performSegue(withIdentifier: "BookingDetailSegue", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // Get reference to the destination view controller
        let detailVC  = segue.destination as! BookingDetailViewController
        // Set the property to the selected location so when the view for
        // detail view controller loads, it can access that property to get the feeditem obj
        detailVC.selectedBooking = selectedBooking
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func returnButtonTapped(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
