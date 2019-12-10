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
    
    func phoneVerification(phoneNumber: String, delegate : OtpSendDelegate?) {
        KVNProgress.show()
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { (verificationID, error) in
            KVNProgress.dismiss(completion: {
                if let localError = error {
                    MyNavigations.navigation.showCommonMessageDialog(message: localError.localizedDescription, buttonTitle: "OK")
                }else{
                    if let verifyId = verificationID{
                        delegate?.onOtpSend(phoneNumber: phoneNumber, verificationID: verifyId)
                    }else{
                        MyNavigations.navigation.showCommonMessageDialog(message: MyConstants.STATIC_ERROR_MESSAGE, buttonTitle: "OK")
                    }
                }
            })
        }
    }
    
    func verifyOTP(navigationController : UINavigationController?, phoneNumber : String, otpValue : String, verificationID : String) {
        KVNProgress.show()
        let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationID, verificationCode: otpValue)
        Auth.auth().signIn(with: credential) { (authResult, error) in
            KVNProgress.dismiss(completion: {
                if let localError = error {
                    MyNavigations.navigation.showCommonMessageDialog(message: localError.localizedDescription, buttonTitle: "OK")
                }else{
                    CommonWebServices.api.login(navigationController: navigationController, phoneNumber: phoneNumber)
                }
            })
        }
    }
}
