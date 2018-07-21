//
//  HomeViewController.swift
//  GymBuddy
//
//  Created by James Sunley on 05/02/2018.
//  Copyright © 2018 James Sunley. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, NewsHomeModelProtocol {

    var feedItems: NSArray = NSArray()
    var selectedNews : NewsModel = NewsModel()
    @IBOutlet weak var listTableView: UITableView!
    @IBOutlet weak var addNewsButton: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.listTableView.delegate = self
        self.listTableView.dataSource = self
        
        let newsHomeModel = NewsHomeModel()
        newsHomeModel.delegate = self
        newsHomeModel.downloadItems()
        
        NotificationCenter.default.addObserver(self, selector: #selector(loadList), name: NSNotification.Name(rawValue: "load"), object: nil)
        
        //getting user data from defaults
        let defaultValues = UserDefaults.standard
        
        if "0" == defaultValues.string(forKey: "trainer"){
            //hiding the button
            self.navigationItem.rightBarButtonItem = nil
        }else{
            //send back to login view controller
        }
    }
    
    @objc func loadList(){
        let newsHomeModel = NewsHomeModel()
        newsHomeModel.delegate = self
        newsHomeModel.downloadItems()
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
        let news: NewsModel = feedItems[indexPath.row] as! NewsModel
        // Get references to labels of cell
        myCell.textLabel!.text = news.title
        myCell.detailTextLabel?.text = news.overview
        
        return myCell
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func signOutButtonTapped(_ sender: UIBarButtonItem) {
        print ("signout tapped")
        //removing values from default
        UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
        UserDefaults.standard.synchronize()
        
        //switching to login screen
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let LogInViewController = storyboard.instantiateViewController(withIdentifier: "LogInViewController") as! LogInViewController
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = LogInViewController
    }
    
    func tableView(_ listTableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Set selected news to var
        selectedNews = feedItems[indexPath.row] as! NewsModel
        // Manually call segue to detail view controller
        self.performSegue(withIdentifier: "NewsDetailSegue", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "NewsDetailSegue" {
            let detailVC  = segue.destination as! NewsDetailViewController
            detailVC.selectedNews = selectedNews
            //detailVC.match = self.match
        } else if segue.identifier == "AddNewsSegue" {
            let controller = segue.destination as! AddNewsViewController
            //controller.history = self.history
        }
        
//        // Get reference to the destination view controller
//        let detailVC  = segue.destination as! NewsDetailViewController
//        // Set the property to the selected location so when the view for
//        // detail view controller loads, it can access that property to get the feeditem obj
//        detailVC.selectedNews = selectedNews
    }
    
    @IBAction func addNewsButton(_ sender: Any) {
        print("add news tapped")
        performSegue(withIdentifier: "AddNewsSegue", sender: self)
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
