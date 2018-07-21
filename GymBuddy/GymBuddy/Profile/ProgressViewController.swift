//
//  ProgressViewController.swift
//  GymBuddy
//
//  Created by James Sunley on 21/03/2018.
//  Copyright © 2018 James Sunley. All rights reserved.
//

import UIKit

class ProgressViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, AllActivityHomeModelProtocol {
    
    @IBOutlet weak var listTableView: UITableView!
    var selectedActivity : ActivityModel = ActivityModel()
    var feedItems: NSArray = NSArray()
    
    override func viewDidLoad() {
        
        self.listTableView.delegate = self
        self.listTableView.dataSource = self
        
        let allActivityHomeModel = AllActivityHomeModel()
        allActivityHomeModel.delegate = self
        allActivityHomeModel.downloadItems()
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(loadList), name: NSNotification.Name(rawValue: "load"), object: nil)
        // Do any additional setup after loading the view.
    }
    
    @objc func loadList(){
        let allActivityHomeModel = AllActivityHomeModel()
        allActivityHomeModel.delegate = self
        allActivityHomeModel.downloadItems()
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
        let activity: ActivityModel = feedItems[indexPath.row] as! ActivityModel
        // Get references to labels of cell
        myCell.textLabel!.text = activity.activity_name
        
        return myCell
    }
    
    func tableView(_ listTableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Set selected session to var
        selectedActivity = feedItems[indexPath.row] as! ActivityModel
        let defaultValues = UserDefaults.standard
        defaultValues.set(selectedActivity.activity_id, forKey: "activityid")
        defaultValues.set(selectedActivity.type, forKey: "type")

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            let detailVC  = segue.destination as! detailProgressViewController
            detailVC.selectedActivity = selectedActivity
            
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func retrunButtonTapped(_ sender: Any) {
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
