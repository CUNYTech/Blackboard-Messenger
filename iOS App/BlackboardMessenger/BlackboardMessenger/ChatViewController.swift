//
//  ChatViewController.swift
//  BlackboardMessenger
//
//  Created by William Wu on 3/29/17.
//  Copyright © 2017 CUNYCodes. All rights reserved.
//

import UIKit
import ActionCableClient

class ChatViewController: UIViewController, UITextFieldDelegate {
	@IBOutlet weak var selectedCourse : UILabel!
	var userDefaults : UserDefaults!
	var client : ActionCableClient? = nil
	@IBOutlet weak var messageContent : UITextField!
	weak var messageView : MessagesTableViewController?
	var roomChannel : Channel!
	@IBOutlet weak var scrollView : UIScrollView!
	
	@IBAction func messageButton(_ sender: Any) {
		if messageContent.text != "" {
			if let message = messageContent.text {
				let user_id = self.userDefaults.object(forKey: "user_id")
				let class_id = self.userDefaults.object(forKey: "class_id")
				roomChannel?["speak"](["content" : message,
				                       "classroom_id" : class_id!,
				                       "user_id" : user_id!])
				
				messageContent.text = ""
				
				self.roomChannel?.onReceive = { (JSON : Any?, error : Error?) in
					self.messageView = self.childViewControllers[0] as? MessagesTableViewController
					self.messageView?.messageArray.append(JSON! as! [String: Any?])
					self.messageView?.tableView.reloadData()
					self.messageView?.tableView.scrollToBottom()
				}
			}
		}
	}
	
	override func viewDidLoad() {
        super.viewDidLoad()
		userDefaults = UserDefaults.standard
		selectedCourse.text = userDefaults.object(forKey: "className") as! String?
		
		connect()
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
    }
	
	func keyboardWillShow(notification: NSNotification) {
		if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
			if self.scrollView.frame.origin.y == 0 {
				let userDefaults = UserDefaults.standard
				let tabBarHeight = userDefaults.object(forKey: "tabHeight") as! CGFloat
				scrollView.setContentOffset(CGPoint(x: 0.0, y: keyboardSize.height - tabBarHeight), animated: true)
			}
		}
	}
	
	override func viewDidAppear(_ animated: Bool) {
		DispatchQueue.main.async {
			self.roomChannel?.onReceive = { (JSON : Any?, error : Error?) in
				self.messageView = self.childViewControllers[0] as? MessagesTableViewController
				self.messageView?.messageArray.append(JSON! as! [String: Any?])
				self.messageView?.tableView.reloadData()
				self.messageView?.tableView.scrollToBottom()
			}
		}
	}
	
	func connect() {
		self.client = ActionCableClient(url: URL(string: "ws://blackboard-messenger.herokuapp.com/cable")!)
		self.client!.connect()
		print("Connecting")
		client?.onConnected = {
			print("Connected")
			self.roomChannel = self.client?.create("ClassChatChannel")
		}
		client?.onDisconnected = {(error: Error?) in
			print("Disconnected!")
		}
	}
	
	func textFieldDidEndEditing(_ textField: UITextField) {
		scrollView.setContentOffset(CGPoint(x: 0.0, y: 0.0), animated: true)
	}

	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		textField.resignFirstResponder()
		return true
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
