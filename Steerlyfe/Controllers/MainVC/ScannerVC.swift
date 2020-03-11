//
//  ScannerVC.swift
//  Steerlyfe
//
//  Created by Nap Works on 26/02/20.
//  Copyright © 2020 napworks. All rights reserved.
//

import UIKit
import AVFoundation

class ScannerVC: UIViewController, AVCaptureMetadataOutputObjectsDelegate, ProductsListDelegate {
    
    let TAG = "ScannerVC"
    
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    var isRunning = true
    
    @IBOutlet weak var scanningLineView: UIView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var scannerContainer: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black
        var headerColor = UIColor.black
        headerColor = headerColor.withAlphaComponent(0.1)
        headerView.backgroundColor = headerColor
        
        CommonMethods.roundCornerFilledGradient(uiView: scanningLineView, cornerRadius: 2.0)
        
        captureSession = AVCaptureSession()
        
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        let videoInput: AVCaptureDeviceInput
        
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }
        
        if (captureSession.canAddInput(videoInput)) {
            captureSession.addInput(videoInput)
        } else {
            failed()
            return
        }
        
        let metadataOutput = AVCaptureMetadataOutput()
        
        if (captureSession.canAddOutput(metadataOutput)) {
            captureSession.addOutput(metadataOutput)
            
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
//            metadataOutput.metadataObjectTypes = [.ean8, .ean13, .pdf417, .qr, .code128, .code39, .code93,.code39Mod43]
            metadataOutput.metadataObjectTypes = [.ean8, .ean13, .code93, .code39, .code128, .code39Mod43]
        } else {
            failed()
            return
        }
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = scannerContainer.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        scannerContainer.layer.addSublayer(previewLayer)
        
        captureSession.startRunning()
        
        
        //        let x : CGFloat = 20.0
        //        let y : CGFloat = ( self.view.frame.height / 2.0) - (self.scanningLineView.frame.height / 2.0)
        //        let width : CGFloat = self.view.frame.width - ( x * 2.0)
        //        let height : CGFloat = self.view.frame.height
        //        self.scanningLineView.frame = CGRect(x: 20, y: y, width: width, height: height)
        //        UIView.animate(withDuration: 2.0, delay: 0, options: [.repeat, .autoreverse] , animations: {
        //            self.scanningLineView.frame = CGRect(x: x, y: y, width: width, height: height);
        //
        //        }) { (completed) in
        //            CommonMethods.showLog(tag: self.TAG, message: "COMPLETED")
        //        }
        
        
    }
    
    func showAnimation(moveUp : Bool, count : Int) {
        var duration = 0.0
        if count > 1{
            duration = 1.0
        }
        UIView.animate(withDuration: duration, delay: 0.0, options: [.curveEaseOut], animations: {
            if moveUp{
                self.scanningLineView.center.y -= self.view.frame.height
            }else{
                self.scanningLineView.center.y += self.view.frame.height
            }
            self.scanningLineView.layoutIfNeeded()
        }) { (completed) in
            if self.isRunning{
                if moveUp{
                    self.scanningLineView.center.y = 0
                }else{
                    self.scanningLineView.center.y = self.view.frame.height
                }
                self.showAnimation(moveUp: !moveUp, count: count + 1)
            }
        }
        
    }
    
    func failed() {
        let ac = UIAlertController(title: "Scanning not supported", message: "Your device does not support scanning a code from an item. Please use a device with a camera.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
        captureSession = nil
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        if (captureSession?.isRunning == false) {
            captureSession.startRunning()
        }
        isRunning = true
        self.scanningLineView.center.y = 0
        showAnimation(moveUp: false, count: 0)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if (captureSession?.isRunning == true) {
            captureSession.stopRunning()
        }
        isRunning = false
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        captureSession.stopRunning()
        
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            found(code: stringValue)
        }
        dismiss(animated: true)
    }
    
    func found(code: String) {
        CommonMethods.showLog(tag: TAG, message: "code : \(code)")
        if code.count > 0{
            CommonWebServices.api.getProductDetailWithBarcode(navigationController: navigationController, barcode: code, delegate: self)
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    @IBAction func closeViewController(_ sender: Any) {
        CommonMethods.showLog(tag: TAG, message: "closeViewController")
        CommonMethods.dismissCurrentViewController()
    }
    
    func onProductListReceived(status: String, message: String, data: CategoryProductsResponse?) {
        CommonMethods.showLog(tag: TAG, message: "status : \(status)")
        CommonMethods.showLog(tag: TAG, message: "message : \(message)")
        CommonMethods.showLog(tag: TAG, message: "SIZE : \(data?.productList.count ?? 0)")
        switch status {
        case "1":
            if data?.productList.count ?? 0 > 0{
                MyNavigations.goToCommonProductsList(navigationController: navigationController, listData: data?.productList ?? [], pageTitle: "Products")
            }else{
                MyNavigations.showCommonMessageDialog(message: "No product available for this barcode", buttonTitle: "OK")
                if (captureSession?.isRunning == false) {
                    captureSession.startRunning()
                }
            }
            break
        default:
            MyNavigations.showCommonMessageDialog(message: message, buttonTitle: "OK")
            break
        }
    }
    
}
