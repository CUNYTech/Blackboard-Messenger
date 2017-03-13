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
	@IBOutlet weak var usernameField: UITextField!
	@IBOutlet weak var passwordField: UITextField!
	@IBAction func loginButton(_ sender: UIButton) {
		Alamofire.request(
			"https://blackboard-api-isuruv.c9users.io/api/users/sign_in",
			method: .post,
			parameters: ["username" : usernameField,
			             "password" : passwordField]
			)
			.responseJSON { response in
				print(response.request)
				print(response.response)
				print(response.data)
				print(response.result)
				
				if let JSON = response.result.value {
					print("JSON: \(JSON)")
				}
		}
	}

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
