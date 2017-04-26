//
//  SettingsViewController.swift
//  BlackboardMessenger
//
//  Created by William Wu on 3/28/17.
//  Copyright © 2017 CUNYCodes. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
	var userDefaults : UserDefaults?
	
	@IBAction func logOutButton(_ sender: Any) {
		userDefaults?.removeObject(forKey: "student")
		performSegue(withIdentifier: "logOutSegue", sender: self)
	}

    override func viewDidLoad() {
        super.viewDidLoad()
		userDefaults = UserDefaults.standard
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
