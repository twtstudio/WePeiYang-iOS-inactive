//
//  AboutViewController.swift
//  WePeiYang
//
//  Created by Qin Yubo on 16/1/30.
//  Copyright © 2016年 Qin Yubo. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {
    
    @IBOutlet weak var versionLabel: UILabel!
    @IBOutlet weak var twtIcon: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "关于"
        self.versionLabel.text = "\(wpyDeviceStatus.getAppVersion()) Build \(wpyDeviceStatus.getAppBuild())"
        
        twtIcon.userInteractionEnabled = true
        twtIcon.addGestureRecognizer({
            let tapRecognizer = UITapGestureRecognizer().bk_initWithHandler({(recognizer, state, point) in
                
                if NSUserDefaults().boolForKey(DEV_MODE_PASSWORD_NOT_REQUIRED) == true {
                    let devController = DevControlViewController(style: .Grouped)
                    self.presentViewController(UINavigationController(rootViewController: devController), animated: true, completion: nil)
                } else {
                    let authAlert = UIAlertController(title: "DevKit", message: "Please enter dev key", preferredStyle: .Alert)
                    authAlert.addTextFieldWithConfigurationHandler({ textField in
                        textField.secureTextEntry = true
                    })
                    let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .Cancel, handler: nil)
                    let okAction = UIAlertAction(title: "OK", style: .Default, handler: { action in
                        let devController = DevControlViewController(style: .Grouped)
                        self.presentViewController(UINavigationController(rootViewController: devController), animated: true, completion: nil)
                    })
                    authAlert.addAction(okAction)
                    authAlert.addAction(cancelAction)
                    self.presentViewController(authAlert, animated: true, completion: nil)
                }
                
            }) as! UITapGestureRecognizer
            tapRecognizer.numberOfTapsRequired = NSUserDefaults.standardUserDefaults().boolForKey(DEV_MODE_PASSWORD_NOT_REQUIRED) == true ? 1 : 10
            return tapRecognizer
        }())
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
