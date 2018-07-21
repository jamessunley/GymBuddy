//
//  DetailSessionViewController.swift
//  GymBuddy
//
//  Created by James Sunley on 26/02/2018.
//  Copyright © 2018 James Sunley. All rights reserved.
//

import UIKit
import Alamofire

class DetailSessionViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, ActivityHomeModelProtocol {

    @IBOutlet weak var listTableView: UITableView!
    var feedItems: NSArray = NSArray()
    var selectedSession : SessionModel?
    var selectedActivity : ActivityModel = ActivityModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let leftButton = UIBarButtonItem(title: "Add Activity", style: .plain, target: self, action: #selector(self.someFunc))
        self.navigationItem.rightBarButtonItem = leftButton
        
        self.listTableView.delegate = self
        self.listTableView.dataSource = self

        let activityHomeModel = ActivityHomeModel()
        activityHomeModel.delegate = self
        activityHomeModel.downloadItems()

        NotificationCenter.default.addObserver(self, selector: #selector(loadList), name: NSNotification.Name(rawValue: "load"), object: nil)
        // Do any additional setup after loading the view.
    }
    
    @objc func loadList(){
        let activityHomeModel = ActivityHomeModel()
        activityHomeModel.delegate = self
        activityHomeModel.downloadItems()
        self.listTableView.reloadData()
    }
    
    func itemsDownloaded(items: NSArray) {
        
        feedItems = items
        self.listTableView.reloadData()
    }
    
    @objc func someFunc() {
        performSegue(withIdentifier: "AddActivitySegue", sender: self)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feedItems.count;
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        // action two
        let deleteAction = UITableViewRowAction(style: .default, title: "Delete", handler: { (action, indexPath) in
            print("Delete tapped")
            let session_id = Int(self.selectedSession!.session_id!)
            
            let activity: ActivityModel = self.feedItems[indexPath.row] as! ActivityModel
            let activity_id = activity.activity_id
            let parameters: Parameters=[
                "activity_id":activity_id!,
                "session_id":session_id!
            ]
            Alamofire.request("http://94.12.191.140/api_test/v1/activity_session_delete.php", method: .post, parameters: parameters, encoding: URLEncoding()).responseJSON
                {
                    response in
                    //printing response
                    print(response)
            }
            
            self.loadList()
        })
        
        deleteAction.backgroundColor = UIColor.red
        
        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Retrieve cell
        let cellIdentifier: String = "BasicCell"
        let myCell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)!
        // Get the news to be shown
        let activity: ActivityModel = feedItems[indexPath.row] as! ActivityModel
        // Get references to labels of cell
        myCell.textLabel!.text = activity.activity_name
        if (activity.completed == "0"){
            myCell.accessoryType = .none
        }else if(activity.completed == "1"){
            myCell.accessoryType = .checkmark
        }
        
        return myCell
    }
    
    func tableView(_ listTableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Set selected session to var
        selectedActivity = feedItems[indexPath.row] as! ActivityModel
        
        // Manually call segue to detail view controller
        self.performSegue(withIdentifier: "ActivityDetailSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "ActivityDetailSegue" {
            let detailVC  = segue.destination as! WorkoutWeightsViewController
            detailVC.selectedActivity = selectedActivity
            //detailVC.match = self.match
        } else if segue.identifier == "AddActivitySegue" {

        }
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

}
