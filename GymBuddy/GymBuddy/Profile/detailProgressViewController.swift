//
//  detailProgressViewController.swift
//  GymBuddy
//
//  Created by James Sunley on 21/03/2018.
//  Copyright © 2018 James Sunley. All rights reserved.
//

import UIKit

class detailProgressViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, ProgressHomeModelProtocol {

    @IBOutlet weak var listTableView: UITableView!
    var selectedProgress : ProgressModel = ProgressModel()
    var feedItems: NSArray = NSArray()
    var selectedActivity : ActivityModel?
    var selectedProgress2 : ProgressModel = ProgressModel()
    override func viewDidLoad() {
        
        self.listTableView.delegate = self
        self.listTableView.dataSource = self
        
        let progressHomeModel = ProgressHomeModel()
        progressHomeModel.delegate = self
        progressHomeModel.downloadItems()
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(loadList), name: NSNotification.Name(rawValue: "load"), object: nil)

        // Do any additional setup after loading the view.
    }
    
    @objc func loadList(){
        let progressHomeModel = ProgressHomeModel()
        progressHomeModel.delegate = self
        progressHomeModel.downloadItems()
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
        let activity: ProgressModel = feedItems[indexPath.row] as! ProgressModel
        // Get references to labels of cell
        myCell.textLabel!.text = activity.planned_date
        let defaultValues = UserDefaults.standard
        if (defaultValues.string(forKey: "type") == "W"){
            let weight = "Weight: " + activity.weightORtime!
            myCell.detailTextLabel?.text = weight + " Reps: " + activity.repsORdistance! + " Sets: " + activity.setsORlaps!
        }else if(defaultValues.string(forKey: "type") == "C"){
            let time = "Time: " + activity.weightORtime!
            myCell.detailTextLabel?.text = time + " Distance: " + activity.repsORdistance! + " Laps: " + activity.setsORlaps!
        }
        return myCell
    }
    
    func tableView(_ listTableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Set selected session to var
        if (selectedProgress.repsORdistance == nil || selectedProgress2.repsORdistance == nil){
            
            if(selectedProgress.repsORdistance == nil){
                selectedProgress = feedItems[indexPath.row] as! ProgressModel
            }else {
                selectedProgress2 = feedItems[indexPath.row] as! ProgressModel
                var compare1 = ""
                let weight1: String
                var compare2 = ""
                let weight2: String
                let defaultValues = UserDefaults.standard
                if (defaultValues.string(forKey: "type") == "W"){
                    weight1 = selectedProgress.planned_date! + ": " + "Weight: " + selectedProgress.weightORtime!
                    compare1 = weight1 + " Reps: " + selectedProgress.repsORdistance! + " Sets: " + selectedProgress.setsORlaps!
                    weight2 = selectedProgress2.planned_date! + ": " + "Weight: " + selectedProgress2.weightORtime!
                    compare2 = weight2 + " Reps: " + selectedProgress2.repsORdistance! + " Sets: " + selectedProgress2.setsORlaps!
                }else if(defaultValues.string(forKey: "type") == "C"){
                    weight1 = selectedProgress.planned_date! + ": " + "Time: " + selectedProgress.weightORtime!
                    compare1 = weight1 + " Distance: " + selectedProgress.repsORdistance! + " Laps: " + selectedProgress.setsORlaps!
                    weight2 = selectedProgress2.planned_date! + ": " + "Time: " + selectedProgress2.weightORtime!
                    compare2 = weight2 + " Distance: " + selectedProgress2.repsORdistance! + " Laps: " + selectedProgress2.setsORlaps!
                }
                
                let alertController = UIAlertController(title: "Compare", message: compare1 + "\n" + compare2, preferredStyle: .alert)
                self.present(alertController, animated: true, completion: nil)
                let OKAction = UIAlertAction(title: "OK", style: .default)
                { (action: UIAlertAction!)in
                    print ("OK tapped")
                    DispatchQueue.main.async {
                        self.selectedProgress2 = ProgressModel()
                        self.selectedProgress = ProgressModel()

                    }
                }
                alertController.addAction(OKAction)
            }
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
