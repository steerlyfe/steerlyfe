//
//  CommonPhoneVerification.swift
//  Steerlyfe
//
//  Created by nap on 05/10/19.
//  Copyright © 2019 napworks. All rights reserved.
//

import UIKit
import Firebase
import KVNProgress

class CommonPhoneVerification {
    
    let TAG = "CommonPhoneVerification"
    static let common = CommonPhoneVerification()
    
    init() {
        
    }
    
    func phoneVerification(callingCode : String, phoneNumber: String, delegate : OtpSendDelegate?) {
        if !MyConstants.FILL_STATIC_FORM{
            KVNProgress.show()
        }
        let completeNumber = "+\(callingCode)\(phoneNumber)"
        PhoneAuthProvider.provider().verifyPhoneNumber(completeNumber, uiDelegate: nil) { (verificationID, error) in
            if !MyConstants.FILL_STATIC_FORM{
                KVNProgress.dismiss(completion: {
                    if let localError = error {
                        MyNavigations.showCommonMessageDialog(message: localError.localizedDescription, buttonTitle: "OK")
                    }else{
                        if let verifyId = verificationID{
                            delegate?.onOtpSend(callingCode: callingCode, phoneNumber: phoneNumber, verificationID: verifyId)
                        }else{
                            MyNavigations.showCommonMessageDialog(message: MyConstants.STATIC_ERROR_MESSAGE, buttonTitle: "OK")
                        }
                    }
                })
            }else{
                if let localError = error {
                    MyNavigations.showCommonMessageDialog(message: localError.localizedDescription, buttonTitle: "OK")
                }else{
                    if let verifyId = verificationID{
                        delegate?.onOtpSend(callingCode: callingCode, phoneNumber: phoneNumber, verificationID: verifyId)
                    }else{
                        MyNavigations.showCommonMessageDialog(message: MyConstants.STATIC_ERROR_MESSAGE, buttonTitle: "OK")
                    }
                }
                
            }
            
        }
    }
    
    func verifyOTP(navigationController : UINavigationController?, callingCode : String, phoneNumber : String, otpValue : String, verificationID : String) {
        KVNProgress.show()
        let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationID, verificationCode: otpValue)
        Auth.auth().signIn(with: credential) { (authResult, error) in
            KVNProgress.dismiss(completion: {
                if let localError = error {
                    MyNavigations.showCommonMessageDialog(message: localError.localizedDescription, buttonTitle: "OK")
                }else{
                    CommonWebServices.api.login(navigationController: navigationController, callingCode: callingCode, phoneNumber: phoneNumber)
                }
            })
        }
    }
}
