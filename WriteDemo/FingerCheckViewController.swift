//
//  FingerCheckViewController.swift
//  WriteDemo
//
//  Created by 三斗 on 16/1/18.
//  Copyright © 2016年 com.streamind. All rights reserved.
//

import UIKit
import LocalAuthentication

class FingerCheckViewController: UIViewController {
    var authButton: UIButton?
    var error:NSError?
    var alert:UIAlertController?
    override func viewDidLoad() {
        super.viewDidLoad()
        authButton = UIButton(type: .System)
        authButton?.frame = CGRect(x: (view.bounds.width - 80)/2, y: (view.bounds.height - 80)/2, width: 80, height: 80)
        authButton?.setBackgroundImage(UIImage(named: "fingerprint"), forState: .Normal)
        authButton?.addTarget(self, action: Selector("check:"), forControlEvents: .TouchUpInside)
        view.addSubview(authButton!)
        // Do any additional setup after loading the view.
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func check(sender:UIButton!){
        print("success")
        let laContext = LAContext()
        if laContext.canEvaluatePolicy(LAPolicy.DeviceOwnerAuthenticationWithBiometrics, error: &error){
            laContext.evaluatePolicy(.DeviceOwnerAuthenticationWithBiometrics, localizedReason: "请验证已有指纹", reply: { (success, error) -> Void in
                if success{
                    print("成功")
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        if let navViewController = self.storyboard!.instantiateViewControllerWithIdentifier("indexNav") as? UINavigationController{
                            self.presentViewController(navViewController, animated: false, completion: nil)
                        }
                    })
                }else{
                    print("\(self.error)")
                }
         })
        }else{
        alert = UIAlertController(title: "失败", message: "指纹识别未启用", preferredStyle:.Alert)
        let action = UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel , handler:nil)
        alert?.addAction(action)
        presentViewController(alert!, animated: true, completion: nil)
        }

    }
//    func alertError(){
//        if(alert !=nil){
//            alert = UIAlertController(title: "", message: String?, preferredStyle: UIAlertControllerStyle)
//        }
//    
//    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
