//
//  QRCodeViewController.swift
//  WriteDemo
//
//  Created by 三斗 on 16/1/17.
//  Copyright © 2016年 com.streamind. All rights reserved.
//

import UIKit
import AVFoundation

class QRCodeViewController: UIViewController,AVCaptureMetadataOutputObjectsDelegate {
    var session:AVCaptureSession?
    var previewLayer:AVCaptureVideoPreviewLayer?
    var scan:UIView?
    var test:UIView?
    var alert:UIAlertController?
    var url:NSURL?
    @IBOutlet weak var QRLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //test!.backgroundColor = UIColor.blackColor()
        //view.addSubview(test!)
        //view.bringSubviewToFront(test!)
        scanSomething()
            }
    func scanSomething(){
        session = AVCaptureSession()
        let device = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        do{
            let input = try AVCaptureDeviceInput(device: device)
            session?.addInput(input)
        }catch{
            print("没有摄像头！")
        }
        test = UIView()
        test?.backgroundColor = UIColor.blackColor()
        test?.frame = view.bounds
        view.addSubview(test!)
        view.bringSubviewToFront(test!)
        let output = AVCaptureMetadataOutput()
        session?.addOutput(output)
        output.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
        output.metadataObjectTypes = [AVMetadataObjectTypeQRCode,AVMetadataObjectTypeEAN13Code,AVMetadataObjectTypeFace]
        previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
        //previewLayer?.backgroundColor = .CGColor
        previewLayer?.frame = view.layer.bounds
        view.layer.addSublayer(previewLayer!)
        //        UIApplication.sharedApplication().windows.first?.backgroundColor = UIColor(red: 255, green: 255, blue: 255, alpha: 1)
        view.bringSubviewToFront(QRLabel)
        session?.startRunning()
        scan = UIView()
        scan?.layer.borderColor = UIColor.greenColor().CGColor
        scan?.layer.borderWidth = 2
        view.addSubview(scan!)
        view.bringSubviewToFront(scan!)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
        if metadataObjects == nil || metadataObjects.count == 0{
            QRLabel.text = "正在扫描中"
        }
        if let object = metadataObjects.first as? AVMetadataFaceObject{
            if object.type == AVMetadataObjectTypeFace{
                if let faceObject = previewLayer?.transformedMetadataObjectForMetadataObject(object){
                    scan?.frame = faceObject.bounds
                    QRLabel.text = "检测到人脸"
                    print(QRLabel.text)
                }
            }
        }
        
        if let object = metadataObjects.first as? AVMetadataMachineReadableCodeObject{
            if let machineCode = previewLayer?.transformedMetadataObjectForMetadataObject(object){
                scan?.frame = machineCode.bounds
            }
            switch object.type{
            case AVMetadataObjectTypeQRCode:
                if let url = NSURL(string: object.stringValue){
                    UIApplication.sharedApplication().openURL(url)
                    
                }
                //QRLabel.text = "这是二维码\(object.stringValue)"
                //print(QRLabel.text)
                
            case AVMetadataObjectTypeEAN13Code:
                alert = UIAlertController(title: "这是商品码", message: "\(object.stringValue)", preferredStyle: .Alert)
                let action = UIAlertAction(title: "确定", style: .Cancel, handler: nil)
                alert?.addAction(action)
                presentViewController(alert!, animated: true, completion: nil)
               // QRLabel.text = "这是商品码\(object.stringValue)"
                //print(QRLabel.text)
            default:return
            }
        }
        
        //if metadataObjects.first == nil || metadataObjects.count == 0{
        //QRLabel.text = "正在扫描中"
        //}
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
