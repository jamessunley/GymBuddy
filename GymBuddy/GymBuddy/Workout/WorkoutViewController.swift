//
//  WorkoutViewController.swift
//  GymBuddy
//
//  Created by James Sunley on 26/02/2018.
//  Copyright © 2018 James Sunley. All rights reserved.
//

import UIKit


class WorkoutViewController: UIViewController,UITableViewDataSource, UITableViewDelegate,SessionHomeModelProtocol {

    var feedItems: NSArray = NSArray()
    var selectedSession : SessionModel = SessionModel()
    @IBOutlet weak var listTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.listTableView.delegate = self
        self.listTableView.dataSource = self
        
        let sessionHomeModel = SessionHomeModel()
        sessionHomeModel.delegate = self
        sessionHomeModel.downloadItems()
        NotificationCenter.default.addObserver(self, selector: #selector(loadList), name: NSNotification.Name(rawValue: "load"), object: nil)

        // Do any additional setup after loading the view.
    }
    @IBAction func myUnwindAction(unwindSegue: UIStoryboardSegue){
        
    }
    
    @objc func loadList(){
        let sessionHomeModel = SessionHomeModel()
        sessionHomeModel.delegate = self
        sessionHomeModel.downloadItems()
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
        let session: SessionModel = feedItems[indexPath.row] as! SessionModel
        // Get references to labels of cell
        myCell.textLabel!.text = session.planned_date
        
        return myCell
    }
    
    func tableView(_ listTableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Set selected session to var
        selectedSession = feedItems[indexPath.row] as! SessionModel
        //the defaultvalues to store session data
        let defaultValues = UserDefaults.standard
        defaultValues.set(selectedSession.session_id, forKey: "sessionid")
        // Manually call segue to detail view controller
        self.performSegue(withIdentifier: "SessionDetailSegue", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // Get reference to the destination view controller
        let detailVC  = segue.destination as! DetailSessionViewController
        // Set the property to the selected location so when the view for
        // detail view controller loads, it can access that property to get the feeditem obj
        detailVC.selectedSession = selectedSession
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signOutButtonTapped(_ sender: UIBarButtonItem) {
        //removing values from default
        UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
        UserDefaults.standard.synchronize()
        
        //switching to login screen
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let LogInViewController = storyboard.instantiateViewController(withIdentifier: "LogInViewController") as! LogInViewController
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = LogInViewController
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
