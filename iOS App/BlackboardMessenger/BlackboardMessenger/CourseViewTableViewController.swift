//
//  CourseViewTableViewController.swift
//  BlackboardMessenger
//
//  Created by William Wu on 2/22/17.
//  Copyright © 2017 CUNYCodes. All rights reserved.
//

import UIKit

class CourseViewTableViewController: UITableViewController {
	var course : [String : Any]!
	var courseInfo : NSArray!
	var studentInfo : [String : Any]!
	var userDefaults : UserDefaults!
	
    override func viewDidLoad() {
        super.viewDidLoad()
		//tableView.contentInset.top = 20

		userDefaults = UserDefaults.standard
		/*
		if(userDefaults.object(forKey: "student") == nil) {
			performSegue(withIdentifier: "BringToLogin", sender: self)
		}
		*/
		tableView.tableFooterView = UIView(frame: .zero)

		studentInfo = userDefaults.object(forKey: "student") as! [String : Any]
		courseInfo = userDefaults.object(forKey: "userClasses") as! NSArray
		
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if let courseCount = self.courseInfo?.count {
			return courseCount
		}
		else {
			return 0
		}
    }

	
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CourseCell", for: indexPath) as! CourseCell

		course = courseInfo.object(at: indexPath.row) as! [String : Any]
		cell.courseName.text = course["classname"] as? String    // Configure the cell...
		
        return cell
    }
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let selectedCourse = self.courseInfo[indexPath.row] as! [String : Any]
		userDefaults.set(selectedCourse["roster"], forKey: "courseRoster")
		userDefaults.set(selectedCourse["classname"], forKey: "className")
		userDefaults.synchronize()
		
		performSegue(withIdentifier: "ShowChat", sender: self)
	}

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
