//
//  MoreViewController.swift
//  TalkTalk
//
//  Created by heojowon on 27/01/2019.
//  Copyright © 2019 heojowon. All rights reserved.
//

import UIKit
import Firebase

class MoreViewController: UIViewController {
    
    var userModel: UserModel?
    
    @IBOutlet var emailLabel: UILabel!
    
    @IBAction func logoutButton(_ sender: Any) {
        
        do {
            try Auth.auth().signOut()
        } catch  {
            
        }
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "더보기"
 
        emailLabel.text = Auth.auth().currentUser?.email

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
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
