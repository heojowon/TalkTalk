//
//  ViewController.swift
//  TalkTalk
//
//  Created by heojowon on 21/01/2019.
//  Copyright © 2019 heojowon. All rights reserved.
//

import UIKit
import Firebase
import SnapKit

class ViewController: UIViewController {

    var box = UIImageView()
    var remoteConfig : RemoteConfig!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        remoteConfig = RemoteConfig.remoteConfig()
        remoteConfig.configSettings = RemoteConfigSettings(developerModeEnabled: true)
        remoteConfig.setDefaults(fromPlist: "RemoteConfigDefaults")
        
        // TimeInterval is set to expirationDuration here, indicating the next fetch request will use
        // data fetched from the Remote Config service, rather than cached parameter values, if cached
        // parameter values are more than expirationDuration seconds old. See Best Practices in the
        // README for more information.
        remoteConfig.fetch(withExpirationDuration: TimeInterval(0)) { (status, error) -> Void in
            if status == .success {
                print("Config fetched!")
                self.remoteConfig.activateFetched()
            } else {
                print("Config not fetched")
                print("Error: \(error?.localizedDescription ?? "No error available.")")
            }
            self.displayWelcome()
        }
        
        self.view.addSubview(box)
        box.snp.makeConstraints { (m) in
            m.center.equalTo(self.view)
            m.height.width.equalTo(128)
        }
        box.image =  #imageLiteral(resourceName: "splash")
        // self.view.backgroundColor = UIColor(hex: "#ffffff")
    }
    
    func displayWelcome(){
        _ = remoteConfig["bi_color"].stringValue
        let caps = remoteConfig["splash_message_caps"].boolValue
        let message = remoteConfig["splash_message"].stringValue
        
        if(caps) {
            let alert = UIAlertController(title: "공지사항", message: message, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "확인", style: UIAlertAction.Style.default, handler: { (action) in
                exit(0)
            }))
            self.present(alert, animated: true, completion: nil)
        }else{
            let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
            self.present(loginVC, animated: false, completion: nil)
        }
        // self.view.backgroundColor = UIColor(hex: color!)
        
    }

        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispase od any resources that can be recreated.
        }
        
    }
    
    extension UIColor {
        convenience init(hex: String) {
            let scanner = Scanner(string: hex)
            scanner.scanLocation = 1
            
            var rgbValue: UInt64 = 0
            
            scanner.scanHexInt64(&rgbValue)
            
            let r = (rgbValue & 0xff0000) >> 16
            let g = (rgbValue & 0xff00) >> 8
            let b = rgbValue & 0xff
            
            self.init(
                red: CGFloat(r) / 0xff,
                green: CGFloat(g) / 0xff,
                blue: CGFloat(b) / 0xff, alpha: 1
            )
        }
    }
    
    let color = UIColor(hex: "ff0000")
