//
//  ViewController.swift
//  WriteDemo
//
//  Created by 三斗 on 16/1/8.
//  Copyright © 2016年 com.streamind. All rights reserved.
//

import UIKit
import MediaPlayer
import MobileCoreServices
import AVFoundation

class ViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    var alert: UIAlertController?
    let deviceInfo = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
    var isOn = false
    @IBOutlet weak var offLight: UIButton!
    
    @IBAction func photo(sender: AnyObject) {
    let imagePicker = UIImagePickerController()
    imagePicker.delegate = self
    imagePicker.sourceType = .Camera
    imagePicker.mediaTypes = [kUTTypeImage as String]
    imagePicker.showsCameraControls = true
    self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func lightChange(sender: AnyObject) {
        if(deviceInfo.hasTorch){
            do{
                try deviceInfo?.lockForConfiguration()
                if(isOn){
                //offLight.setImage(", forState: )
                    offLight.setImage(UIImage(named: "light-on.png"), forState: .Normal)
                    deviceInfo.torchMode = AVCaptureTorchMode.On
                    
                }else{
                     offLight.setImage(UIImage(named: "light-off.png"), forState: .Normal)
                    deviceInfo.torchMode = AVCaptureTorchMode.Off
                }
                isOn = !isOn
                deviceInfo.unlockForConfiguration()
            }catch{
                return
                
            }
        }else{
            putAlert("没有闪光灯你开个杰宝")
        }
    }

    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]){
         let image = info[UIImagePickerControllerOriginalImage] as! UIImage
           saveImage(image)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func saveImage(image:UIImage){
        UIImageWriteToSavedPhotosAlbum(image, self,"image:didFinishSavingWithError:contextInfo:", nil)
    
    }
    
    func image(image:UIImage,didFinishSavingWithError: NSError?, contextInfo: AnyObject) {
        if didFinishSavingWithError != nil {
         putAlert("图片保存失败")
            return
        }
        putAlert("图片保存成功")
    }
    
    func putAlert(title:String){
        
        if(alert == nil){
        alert = UIAlertController(title: title, message: nil, preferredStyle: .Alert)
        let cancel = UIAlertAction(title: "确定", style: .Cancel, handler: nil )
        alert?.addAction(cancel)
        }
        presentViewController(alert!, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController){
    self.dismissViewControllerAnimated(true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func internet(sender: AnyObject) {
        
    
    }
 
    
    
    
}

