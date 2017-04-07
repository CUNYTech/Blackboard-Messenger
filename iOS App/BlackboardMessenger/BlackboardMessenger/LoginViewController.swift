//
//  LoginViewController.swift
//  BlackboardMessenger
//
//  Created by William Wu on 2/22/17.
//  Copyright © 2017 CUNYCodes. All rights reserved.
//

import UIKit
import Alamofire

class LoginViewController: UIViewController {
	var userDefaults : UserDefaults?
	@IBOutlet weak var usernameField: UITextField!
	@IBOutlet weak var passwordField: UITextField!
	
	@IBAction func loginButton(_ sender: UIButton) {
		let requestString = "username=" + usernameField.text! + "&password=" + passwordField.text!
		let urlRequest = "https://shielded-peak-13145.herokuapp.com/blackboard_scrapers/new?" + requestString
		
		Alamofire.request(urlRequest, method: .get,
		                  encoding: JSONEncoding.default, headers:nil)
			.responseJSON { response in
				guard let json = response.result.value as? [String: Any] else{
					print("didn't get courses as JSON from api")
					print("error: \(response.result.error)")
					return
				}
				self.userDefaults = UserDefaults.standard
				self.userDefaults?.set(json["student"] as! [String: Any], forKey: "student")
				var temp = self.userDefaults?.object(forKey: "student") as! [String : Any]
				self.userDefaults?.set(temp["id"], forKey: "user_id")
				self.userDefaults?.set(json["classes"], forKey: "userClasses")
				self.userDefaults?.synchronize()
				
				self.performSegue(withIdentifier: "LoadCourses", sender: self)
		}
	}

    override func viewDidLoad() {
        super.viewDidLoad()
		
		userDefaults = UserDefaults.standard
		if(userDefaults?.object(forKey: "student") != nil) {
			performSegue(withIdentifier: "LoadCourses", sender: self)
		}
		
        // Do any additional setup after loading the view.
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
