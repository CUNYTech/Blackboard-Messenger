//
//  LoginViewController.swift
//  BlackboardMessenger
//
//  Created by William Wu on 2/22/17.
//  Copyright © 2017 CUNYCodes. All rights reserved.
//

import UIKit
import Alamofire

class LoginViewController: UIViewController, UITextFieldDelegate {
	var userDefaults : UserDefaults?
	@IBOutlet weak var usernameField: UITextField!
	@IBOutlet weak var passwordField: UITextField!
	@IBOutlet weak var scrollView: UIScrollView!
	var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
	
	@IBAction func loginButton(_ sender: UIButton) {
		dismissKeyboard()
		if usernameField.text! == "" || passwordField.text! == "" {
			let controller : UIAlertController = UIAlertController(
				title: "Invalid form",
				message: "Please enter your cuny.edu credentials.",
			    preferredStyle: UIAlertControllerStyle.alert)
			
			let okAction : UIAlertAction = UIAlertAction(
				title : "Okay",
				style : UIAlertActionStyle.default,
				handler: {
					(alert: UIAlertAction!) in controller.dismiss(animated: true, completion: nil)}
			)
			
			controller.addAction(okAction)
			self.present(controller, animated: true, completion: nil)
		}
			
		else {
			activityIndicator.center = self.view.center
			activityIndicator.hidesWhenStopped = true
			activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
			view.addSubview(activityIndicator)
			
			activityIndicator.startAnimating()
			UIApplication.shared.beginIgnoringInteractionEvents()
			
			let requestString = "username=" + usernameField.text! + "&password=" + passwordField.text!
			let urlRequest = "https://blackboard-messenger.herokuapp.com/blackboard_scrapers/new?" + requestString
			
			Alamofire.request(urlRequest, method: .get,
			                  encoding: JSONEncoding.default, headers:nil)
				.responseJSON { response in
					guard let json = response.result.value as? [String: Any] else{
						print("didn't get courses as JSON from api")
						print("error: \(String(describing: String(describing: response.result.error)))")
						let controller : UIAlertController = UIAlertController(
							title: "Something went wrong",
							message: "Either the server is down or your credentials were wrong.",
							preferredStyle: UIAlertControllerStyle.alert)
						
						let okAction : UIAlertAction = UIAlertAction(
							title : "Okay",
							style : UIAlertActionStyle.default,
							handler: {
								(alert: UIAlertAction!) in controller.dismiss(animated: true, completion: nil)}
						)
						UIApplication.shared.endIgnoringInteractionEvents()
						controller.addAction(okAction)
						self.present(controller, animated: true, completion: nil)
						return
					}
					self.userDefaults = UserDefaults.standard
					self.userDefaults?.set(json["student"] as! [String: Any], forKey: "student")
					var temp = self.userDefaults?.object(forKey: "student") as! [String : Any]
					self.userDefaults?.set(temp["id"], forKey: "user_id")
					self.userDefaults?.set(json["classes"], forKey: "userClasses")
					self.userDefaults?.synchronize()
					self.activityIndicator.stopAnimating()
					UIApplication.shared.endIgnoringInteractionEvents()
					self.performSegue(withIdentifier: "LoadCourses", sender: self)
			}
		}
	}

    override func viewDidLoad() {
        super.viewDidLoad()
		
		userDefaults = UserDefaults.standard
		
		let tap = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.dismissKeyboard))
		
		view.addGestureRecognizer(tap)
		
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
	}

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		if(userDefaults?.object(forKey: "student") != nil) {
			self.performSegue(withIdentifier: "LoadCourses", sender: self)
		}
	}
	
	func keyboardWillShow(notification: NSNotification) {
		if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
			if self.scrollView.frame.origin.y == 0 {
				scrollView.setContentOffset(CGPoint(x: 0.0, y: keyboardSize.height), animated: true)
			}
		}
	}
	
	func dismissKeyboard() {
		view.endEditing(true)
	}
	
	func textFieldDidEndEditing(_ textField: UITextField) {
		scrollView.setContentOffset(CGPoint(x: 0.0, y: 0.0), animated: true)
	}
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		let nextTag = textField.tag + 1 as Int
		let nextField : UIResponder? = textField.superview?.viewWithTag(nextTag)
		
		if let field : UIResponder = nextField {
			field.becomeFirstResponder()
		}
		else {
			textField.resignFirstResponder()
		}
		return true
	}
	
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
	
    // MARK: - Navigation
/*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		let tabCtrl = segue.destination as! UITabBarController
		_ = tabCtrl.viewControllers?[0] as! CourseViewTableViewController
    }
*/
}
