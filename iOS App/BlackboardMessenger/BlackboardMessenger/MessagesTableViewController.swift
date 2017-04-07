//
//  MessagesTableViewController.swift
//  BlackboardMessenger
//
//  Created by William Wu on 3/29/17.
//  Copyright © 2017 CUNYCodes. All rights reserved.
//

import UIKit
import Alamofire

extension UITableView {
	func scrollToBottom() {
		let sections = numberOfSections-1
		if sections >= 0 {
			let rows = numberOfRows(inSection: sections)-1
			if rows >= 0 {
				let indexPath = IndexPath(row: rows, section: sections)
				DispatchQueue.main.async { [weak self] in
					self?.scrollToRow(at: indexPath, at: .bottom, animated: true)
				}
			}
		}
	}
}

class MessagesTableViewController: UITableViewController {
	var messageArray : NSArray!
	var userDefaults : UserDefaults!
	
    override func viewDidLoad() {
        super.viewDidLoad()
		userDefaults = UserDefaults.standard
		messageArray = userDefaults.object(forKey: "messages") as! NSArray!
		tableView.scrollToBottom()
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
		if let messageCount = self.messageArray?.count {
			return messageCount
		}
		else {
			return 0
		}
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell", for: indexPath) as! MessageCell
		
		let currentMessage = messageArray?[indexPath.row] as! [String : Any]
		let userContent = currentMessage["user"] as! [String : Any]
		let messageContent = currentMessage["message"] as! [String : Any]
		
		if(userContent["id"] as! Int == userDefaults.object(forKey: "user_id") as! Int) {
			cell.outgoingCell.text = userContent["name"] as? String
			cell.outgoingMessage.text = messageContent["content"] as! String
		}
		else {
			cell.userName.text = userContent["name"] as? String
			cell.messageContent.text = messageContent["content"] as! String
		}
        return cell
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
